<template>
  <div>
  <input type="file" accept="image/*;capture=camera" @change="getImage">

    <input type="file" accept="video/*;capture=camcorder">

    <!-- <device type="media" @change="update(this.data)"></device>
<video autoplay ref="streamPlayer"></video> -->
    <canvas ref="qrCanvas" id="myCanvas" width="200" height="100"></canvas>
  </div>
</template>

<script>
import qrcode from 'qrcode';
import jsQR from 'jsqr';

export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  methods: {
    update(stream) {
      this.$refs.streamPlayer.src = stream;
    },
    getImage(event) {
  }
  },
  mounted: function() {
    this.$nextTick(function() {
      qrcode.toDataURL(this.$refs.qrCanvas, "Rajesh Sundaram", (err, str) => {
          console.log(`${err} ---- ${str}`);
        })
        const { data, height, width } = this.$refs.qrCanvas.getContext('2d').getImageData(0,0,116,116);
        // console.log(data);
        console.log('QR CODE DATA=========>'+jsQR(data, width, height).data);
    });
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
#myCanvas {
  /* background: #42b983; */
}
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
