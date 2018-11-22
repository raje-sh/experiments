<template>
  <div>
  <button @click="readQrStream">Start</button>
  <video ref="streamPlayer" height="400" width="400"></video>

  <!-- <input type="file" accept="image/*;capture=camera" @change="getImage">

    <input type="file" accept="video/*;capture=camcorder"> -->

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
  },
  readQrStream() {
    navigator.mediaDevices.getUserMedia({ audio: false, video: true })
    .then(stream => {
      let video = this.$refs.streamPlayer;
      video.srcObject  = stream;
      console.log(stream.getVideoTracks())
      video.onloadedmetadata = function(e) {
    video.play();
  };
    }).catch(console.log);
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
