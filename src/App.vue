<template>
  <div id="app">
<QRScanner></QRScanner>
  </div>
</template>

<script>
import QRScanner from './components/QRScanner.vue'

export default {
  name: 'app',
  components: {
    QRScanner
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
