<template>
  <div id="container">
    <main class="container p-4 mx-auto grid grid-cols-4 md:grid-cols-8 lg:grid-cols-12 gap-2">
      <header class="z-10 mt-6 md:mt-12 col-span-4 md:col-span-8 lg:col-span-12">
        <h1 class="mb-6 font-bold md:mb-12">Welcome to your ship, pilot.</h1>
      </header>
      <div class="z-10 mb-6 md:mb-12 col-span-4 md:col-span-5 lg:col-span-6">
        <h3 v-if="connected" class="font-bold">
          Connected! Access
          <span class='font-extrabold'>{{ decodedAppName }}</span>:
        </h3>
        <h3 v-else class="font-bold">
          {{ headerPrompt }}
           <span class='font-extrabold'>{{ decodedAppName }}</span>
        </h3>
      </div>

      <section class="z-10 mb-6 md:mb-12 col-span-4 md:col-span-5 lg:col-span-12">
        <button v-if="!connected" @click="connectMM">Connect with MetaMask</button>
        <button v-if="connected" @click="signAndLogin">Log in</button>
        <p v-if="errorMessage" class="mt-2 text-sm text-red-600" style="max-width: 50ch;">
          {{ errorMessage }}
        </p>
      </section>

      <section class="col-span-4 md:col-span-3 md:col-span-6">
        <div :style="bgComputerImg" class="hidden md:flex fixed top-[0%]
          max-h-[1200px]
          right-0 lg:w-[50%] md:w-[40%] h-[100%] bg-center bg-contain bg-no-repeat">
        </div>
      </section>

      <div class="col-span-4 md:col-span-8 lg:col-span-12 grid grid-cols-4 md:grid-cols-8 lg:grid-cols-12 gap-2">
        <section id="terminal" class="col-span-4 md:col-span-5 lg:col-span-6">
          <div class="flex flex-col">

            <div class="mb-4">
              <div class="ml-0">
                {
              </div>
                <div class="ml-4">
                  "active_port": "{{ host }}",
                </div>
                <div class="ml-4">
                  "ship_callsign": "~{{ our }}",
                </div>
                <div class="ml-4">
                  "registered_owner": "{{ ownerAddress }}",
                </div>
                <div class="ml-4">
                  "referring_agent": "{{ decodedAppName }}",
                </div>
              <div class="ml-0">
                }
              </div>
            </div>

            <div v-for="(line, i) in dojoLines" :key="i">
              <span>{{ line }}</span>
            </div>
          </div>
        </section>

      </div>
    </main>

    <section class="overflow-clip col-span-4 md:col-span-3 md:col-span-6
      h-[400px]">
      <div :style="bgComputerImg" class="md:hidden h-[400px] w-[135%] bg-center
        bg-contain bg-no-repeat">
      </div>
    </section>

    <transition name="fade">
      <div v-show="loading" >
        <Loader :message="loadingMessage"  />
      </div>
    </transition>

    <footer class="z-10">
      <div class="container flex flex-row justify-between px-4 mx-auto">
        <div>
          <span>&percnt;mask is a product</span>
          <span class="mx-6">of</span>
          <span class="uppercase"><a href="https://vaporware.network">Vaporware</a></span>
        </div>
        <div>
          <a href="https://twitter.com/__vaporware__">Twitter</a>
        </div>
      </div>
    </footer>
  </div>

</template>

<script setup lang="ts">
import {computed, onMounted, ref, watchEffect} from 'vue';

import Loader from '@/components/Loader.vue'
// import bgImage from '@/assets/images/vapor-terminal.png'
import bgImage from '@/assets/images/terminal-big.png'

import Cookies from 'js-cookie'

onMounted(() => {
  // Given:
  // http://localhost:3000/apps/mask/?desk=%25bolton&appRoute=%2Fapps%2Fbolton
  const url = new URL(window.location.href)
  const params = new URLSearchParams(url.search)
  const deskNameFromQuery = params.get('desk')
  const pathFromQuery = params.get('appRoute')

  // get from query params
  if (deskNameFromQuery) {
    loginToApp.value = deskNameFromQuery
  } else {
    loginToApp.value = '%landscape'
  }
  if (pathFromQuery) {
    loginToPath.value = pathFromQuery
  } else {
    loginToPath.value = '/'
  }

  isVaporware.value = params.has('vapor')

  async function redirectIfAuthenticated() {
    // Try to reach the login page /~/login. If the auth cookie is valid, we'll
    // get a `307 MOVED`, and `res.redirected` will be true.
    // In that case, we send the user to pathFromQuery, or else to /apps/grid.
    // Otherwise do nothing.
    const previousLoadingMessage = loadingMessage.value
    try {
      loading.value = true
      loadingMessage.value = "Checking whether you're authenticated"
      const res = await fetch('/~/login')
      if (res.redirected) {
        sendToPath()
      }
    } catch (err) {
      // This means the fetch failed due to network conditions etc.
      // TODO: should this be reflected to user at all? I sort of think not.
      console.error('There was an error while attempting to check auth status.')
    } finally {
      loading.value = false
      // wait until after the fade finishes to reset loadingMessage
      setTimeout(() => (loadingMessage.value = previousLoadingMessage), 500)
    }
  }

  async function getConstants() {
    try {
      const res = await fetch('/apps/mask/login/constants.json')
      if (!res.ok) {
        throw new Error(`request succeeded with non-ok status ${res.code}`)
      }
      const server = res.headers.get('Server')
      const serverVersion = server.slice(server.indexOf('-') + 1)
      vereVersion.value = serverVersion
      const jon = await res.json()
      our.value = jon['SHIP_NAME']
      ownerAddress.value = jon['ETH_ADDRESS']
      challenge.value = jon['CHALLENGE']
    } catch (err) {
      // TODO: I think it might be prudent to fail very loudly here. It's not
      //   likely to happen in production, but if it does, we shouldn't give
      //   the user the impression that it's still possible to sign in. they
      //   should immediately know something's busted.
      console.error('error while fetching constants.json', err)
      our.value = "sampel-palnet"
      ownerAddress.value = '0x33EeCbf908478C10614626A9D304bfe18B78DD73'
      challenge.value = 'sign me pls'
      errorMessage.value = 'Error while fetching ownership information. Is your ship reachable?'
    }
  }

  redirectIfAuthenticated()
  getConstants()
})

const devVersion = ref('v1.0.0-beta')

const errorMessage = ref(false)
const connected = ref(false)
watchEffect((onCleanup) => {
  function handleAccountsChanged(accounts) {
    // if accounts is an Array(0), we are not connected anymore
    connected.value = !!accounts.length
  }
  if (typeof window.ethereum !== 'undefined' && connected.value) {
    window.ethereum.on('accountsChanged', handleAccountsChanged)
    onCleanup(() => window.ethereum.removeListener('accountsChanged', handleAccountsChanged))
  }
})
const host = ref(window.location.host)
const our = ref('sampel-palnet')
const ownerAddress = ref('0x33EeCbf908478C10614626A9D304bfe18B78DD73') // Azimuth
const ownerAddressPrefix = computed(() => ownerAddress.value.slice(0, 6))
const loginToApp = ref("%garden")
const loginToPath = ref("/")
const isVaporware = ref(false)
const vereVersion = ref('2.8')

const challenge = ref('sign this message for access')

const loading = ref(false)
const loadingMessage = ref("Waiting for MetaMask")

const dojoLines = computed(() => [
`%mask version ${devVersion.value}`,
"~",
`urbit ${vereVersion.value}`,
`boot: home is /${ownerAddressPrefix.value}/${our.value}`,
"loom: mapped 2048MB",
"lite: arvo formula 2a2274c9",
"lite: core 4bb376f0",
"lite: final state 4bb376f0",
"loom: mapped 2048MB",
"boot: protected loom",
"live: loaded: MB/277.970.944",
"boot: installed 652 jets",
"---------------- playback starting ----------------",
"pier: replaying events 270-290",
"pier: (290): play: done",
"---------------- playback complete ----------------",
"vere: checking version compatibility",
"loom: image backup complete",
"ames: live on 49694",
`conn: listening on /${ownerAddressPrefix.value}/${our.value}.urb/conn.sock`,
`http: web interface live on ${host.value}`,
"pier (301): live",
"; ~zod is your neighbor",
`~${our.value}:dojo> |`,
])

const bgComputerImg = ref(`background-image: url(${ bgImage })`)

// Whitelist of vaporware-distributed desks. If we're redirecting to one of
// these, the UI will show the Vaporware copy. Otherwise, we use the default.
const vaporwareDesks = new Set([
  '%bolton',
])

const decodedAppName = computed(() => {
  return loginToApp.value
})
const decodedPath = computed(() => {
  if (loginToPath.value) {
    return loginToPath.value
  }
  return ""
})
const headerPrompt = computed(() => {
  if (isVaporware.value || vaporwareDesks.has(decodedAppName.value)) {
    return "Connect your wallet to access the installed vaporware:"
  }
  return "Connect your wallet to access:"
})

const sendToPath = () => {
  window.location.pathname = decodedPath.value
}

const connectMM = async () => {
  errorMessage.value = false
  loading.value = true
  if (typeof window.ethereum === "undefined") {
    errorMessage.value = "Please install MetaMask, or visit through the browser in the MetaMask app."
    loading.value = false
    return;
  }

  // Request accounts and prompt the user to connect
  try {
    const accounts = await window.ethereum.request({ method: "eth_requestAccounts" });
    // now connected
    connected.value = true
  } catch (error) {
    errorMessage.value = "MetaMask connection cancelled"
    console.error("MetaMask connection cancelled:", error);
    connected.value = false
  } finally {
    loading.value = false
  }
}

const signAndLogin = async () => {
  loading.value = true
  errorMessage.value = false

  try {
    // Get the connected account
    const accounts = await window.ethereum.request({ method: "eth_accounts" });
    const account = accounts[0];

    // Sign a message using the connected account
    const message = challenge.value
    const signature = await window.ethereum.request({
      method: "personal_sign",
      params: [account, message],
    });

    console.log("Signed message:", signature);

    const sigPostPath = '/apps/mask/login/submit'
    const body = {
      "eth-address": account,
      signature,
      message,
    }
    const signatureResponse = await fetch(sigPostPath, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(body)
    })

    if (!signatureResponse.ok) {
      throw new Error('Signature got bad response')
    }

    console.log('trying signature response...')
    try {
      const jsonResponse = await signatureResponse.json();

      const cookieString = jsonResponse.split(';')[0]
      // console.log('cookie string ', cookieString)
      const cookieSplit = cookieString.split('=')
      const cookieKey = cookieSplit[0]
      const cookieValue = cookieSplit[1]

      // clear any old cookies with the same key:
      const domain = window.location.hostname

      // set our urbauth cookie from eyre
      Cookies.remove(cookieKey)
      Cookies.set(cookieKey, cookieValue, { path: '/', domain, expires: 365 })
    } catch (err) {
      console.error('error getting cookie from json an setting ', err)
    }


    console.log('got past sendSignature')
    console.log('sending to path ', decodedPath.value)
    // sendToPath()
  } catch (err) {
    errorMessage.value = 'Error sending signature'
    console.error('Error sending signature')
  } finally {
    loading.value = false
  }
};

</script>

