<template>
  <div>
  <button @click="readQrStream">Start</button>
  <button @click="getFrame">update Frame</button>
  <video ref="streamPlayer" height="400" width="400"></video>

<canvas ref="currentframe" width="300" height="300"></canvas>
  <!-- <input type="file" accept="image/*;capture=camera" @change="getImage">

    <input type="file" accept="video/*;capture=camcorder"> -->
{{tracks}}

    <canvas ref="qrCanvas" id="myCanvas" width="200" height="100"></canvas>
  </div>
</template>

<script>
import qrcode from "qrcode";
import jsQR from "jsqr";

export default {
  name: "HelloWorld",
  props: {
    msg: String
  },
  data() {
    return {
      tracks: 0,
      imageFrame: undefined
    };
  },
  methods: {
    update(stream) {
      this.$refs.streamPlayer.src = stream;
    },
    getImage(event) {},
    readQrStream() {
      navigator.mediaDevices
        .getUserMedia({ audio: false, video: true })
        .then(stream => {
          /* stream.onaddtrack((ms, ev) => {
            console.log("added");
          }); */
          let video = this.$refs.streamPlayer;
          video.srcObject = stream;

          this.imageFrame = new ImageCapture(stream.getVideoTracks()[0]);
          console.log(this.imageFrame);
          video.onloadedmetadata = function(e) {
            video.play();
          };
        })
        .catch(console.log);
    },
    getFrame() {
      this.imageCapture
        .grabFrame()
        .then(imageBitmap => {
          console.log(imageBitmap);
          // drawCanvas(this.$refs.currentframe, imageBitmap);
        })
        .catch(error => console.log(error));
    }
  },
  mounted: function() {
    this.$nextTick(function() {
      qrcode.toDataURL(this.$refs.qrCanvas, "Rajesh Sundaram", (err, str) => {
        // console.log(`${err} ---- ${str}`);
      });
      const { data, height, width } = this.$refs.qrCanvas
        .getContext("2d")
        .getImageData(0, 0, 116, 116);
      // console.log(data);
      // console.log('QR CODE DATA=========>'+jsQR(data, width, height).data);
    });
  }
};
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
