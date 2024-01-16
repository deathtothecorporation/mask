<script setup lang="ts">
import {computed} from 'vue'

const props = defineProps({
  message: String,
})

const display = computed(() => `${props.message}...`)
</script>

<template>
    <div class='v-w'>
      <div class="v-text">V</div>
      <template v-for="(value, index) in Array.from({length: 60}, (v, i) => i + 1)">
        <div class='v-g'>
          <template v-for="(value, index) in Array.from({length: 10}, (v, i) => i + 1)">
            <div class='v-e'></div>
          </template>
        </div>
      </template>
    </div>
  <div class="loader-overlay"></div>
  <div class="notice-frame">
    <div class="notice">
      <span>{{ display }}</span>
    </div>
  </div>
</template>

<style scoped>
/* code... */
</style>
