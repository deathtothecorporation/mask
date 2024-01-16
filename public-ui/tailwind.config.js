const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: ['index.html','./src/**/*.{js,jsx,ts,tsx,vue,html}'],
  theme: {
    extend: {
      fontSize: {
        '2xs': '0.6rem',
      },
      colors: {
        'surface': '#E1D9CD',
        'surface-mid': '#cac3b5',
        'surface-dark': '#847C6D',
        'surface-alt': '#394049',
        'header': '#C0B8B5',
        'body-light': '#E5DDCE',
        'body': '#17181F',
        'a-red': '#E15B34',
        'a-blue': '#74BBD9',
        'a-pink': '#cc1fd5',
        'a-green': '#3ad843',
      },
      fontFamily: {
        'sans': ['ultramagnetic', ...defaultTheme.fontFamily.sans],
        'mono': ['JetBrains Mono', ...defaultTheme.fontFamily.mono],
      }
    },
  },
  plugins: [],
}
