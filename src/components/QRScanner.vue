<template>
  <div>
<el-row>
  <el-button @click="readQrStream">Start</el-button>
  <el-button @click="stopScanning">Stop</el-button>
</el-row>
<el-row>
    <video v-if="canStream" ref="streamPlayer" height="400" width="400"></video>
<canvas ref="currentframe" width="300" height="300"></canvas>
    <canvas ref="qrCanvas" id="myCanvas" width="200" height="100"></canvas>
</el-row>

<input type="file" accept="image/*;capture=camera" @change="drawImageToCanvasAndScan">
      </div>
</template>

<script>
import qrcode from "qrcode";
import jsQR from "jsqr";

export default {
  name: "QRScanner",
  props: {
    msg: String
  },
  data() {
    return {
      tracks: 0,
      imageFrame: undefined,
      stream: undefined,
      canStream: true,
      scanIntervalId: undefined,
      decodedData: "",
      scanTimeout: 60000
    };
  },
  watch: {
    canStream: function(oldVal, newVal) {
      if (!newVal) {
        this.imageFrame.track.stop();
      }
    }
  },
  methods: {
    update(stream) {
      this.$refs.streamPlayer.src = stream;
    },
    readQrStream() {
      navigator.mediaDevices
        .getUserMedia({ audio: false, video: true })
        .then(stream => {
          this.stream = stream;
          let video = this.$refs.streamPlayer;
          video.srcObject = stream;
          this.imageFrame = new ImageCapture(stream.getVideoTracks()[0]);
          video.onloadedmetadata = function(e) {
            video.play();
          };
          this.scanIntervalId = setInterval(() => {
            this.getFrame();
          }, 500);
          const tempComp = this;
          setTimeout(() => {
            clearInterval(this.scanIntervalId);
            this.stopScanning();
            this.$notify({
              title: "Scan Timeout Exceeded",
              message: "Please Try Again"
            });
          }, this.scanTimeout);
        })
        .catch(console.log);
    },
    getFrame() {
      this.imageFrame
        .grabFrame()
        .then(imageBitmap => {
          const { data, height, width } = this.transferToImageData(imageBitmap);
          let decoded = jsQR(data, height, width);
          if (decoded) {
            const { data, chunks, location, binaryData } = decoded;
            this.canStream = false;
            this.decodedData = decoded.data;
          }
        })
        .catch(error => console.log(error));
    },
    transferToImageData(imageBitmap) {
      if (imageBitmap instanceof ImageBitmap) {
        let { width, height } = imageBitmap;
        let canvas = document.createElement("canvas");
        canvas.height = height;
        canvas.width = width;
        let ctx = canvas.getContext("2d");
        ctx.drawImage(imageBitmap, 0, 0);
        return ctx.getImageData(0, 0, width, height);
      }
      return;
    },
    stopScanning() {
      this.canStream = false;
    },
    drawImageToCanvasAndScan(event) {}
  },
  mounted: function() {
    this.$nextTick(function() {
      qrcode.toDataURL(this.$refs.qrCanvas, "Rajesh Sundaram", (err, str) => {
        // console.log(`${err} ---- ${str}`);
      });
      const { data, height, width } = this.$refs.qrCanvas
        .getContext("2d")
        .getImageData(0, 0, 116, 116);
      // console.log(jsQR(data, width, height));
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
