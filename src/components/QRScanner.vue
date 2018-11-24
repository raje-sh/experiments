<template>
  <div>
<el-row>
  <el-button @click="readQrStream">Start</el-button>
  <el-button @click="stopScanning">Stop</el-button>
  <input type="file" accept="image/*;capture=camera" @change="drawImageToCanvasAndScan"/>
</el-row>
<el-row>
    <video v-if="canStream" ref="streamPlayer" height="400" width="400"></video>
<canvas ref="currentframe" width="300" height="300"></canvas>
    <canvas ref="qrCanvas" id="myCanvas" width="200" height="100"></canvas>
</el-row>
<div id="temp">
</div>
<div class="decode-box"><span id="data">
  {{decodedData}}
  </span></div>

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
      getFrameInterval: 500,
      scanTimeout: 6000
      // scanTimeout: 60000
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
          }, this.getFrameInterval);
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
        // .grabFrame()
        .takePhoto({ imageHeight: 480, imageWidth: 640 })
        .then(imageBitmapOrBlob => {
          const { data, height, width } = this.transferToImageData(
            imageBitmapOrBlob
          );
          let decoded = jsQR(data, height, width);
          console.log(
            `${data.length}, ${height}, ${width}, ${height *
              width} =========> ${decoded}`
          );
          if (decoded) {
            const { data, chunks, location, binaryData } = decoded;
            this.canStream = false;
            this.decodedData = decoded.data;
          }
        })
        .catch(error => console.log(error));
    },
    async transferToImageData(imageBitmapOrBlob) {
      if (imageBitmapOrBlob instanceof ImageBitmap) {
        let { width, height } = imageBitmapOrBlob;
        let canvas = document.createElement("canvas");
        canvas.height = height;
        canvas.width = width;
        let ctx = canvas.getContext("2d");
        ctx.drawImage(imageBitmapOrBlob, 0, 0);
        document.querySelector("#temp").appendChild(canvas);
        return ctx.getImageData(0, 0, width, height);
      } else if (imageBitmapOrBlob instanceof Blob) {
        const height = 480,
          width = 640;
        let imageFrame = document.createElement("img");
        imageFrame.src = URL.createObjectURL(imageBitmapOrBlob);
        // document.querySelector("#temp").appendChild(imageFrame);
        let canvas = document.createElement("canvas");
        imageFrame.onload = () => {
          canvas.height = height;
          canvas.width = width;
          let ctx = canvas.getContext("2d");
          ctx.drawImage(imageFrame, 0, 0);

          document.querySelector("#temp").appendChild(canvas);
          const decodedData = jsQR(
            ctx.getImageData(0, 0, width, height).data,
            width,
            height
          );
          console.log(`${decodedData.data}`);
          // return ctx.getImageData(0, 0, width, height);
        };
      }
      return;
    },
    stopScanning() {
      this.canStream = false;
    },
    drawImageToCanvasAndScan(event) {
      const qrImage = document.createElement("img");
      qrImage.src = URL.createObjectURL(event.target.files[0]);
      const canvas = document.createElement("canvas");
      qrImage.onload = () => {
        canvas.height = qrImage.naturalHeight;
        canvas.width = qrImage.naturalWidth;
        let ctx = canvas.getContext("2d");
        ctx.drawImage(qrImage, 0, 0);
        let { data, height, width } = ctx.getImageData(
          0,
          0,
          qrImage.naturalWidth,
          qrImage.naturalHeight
        );
        console.log(`${data.length}, ${height}, ${width}, ${height * width}`);
        const decodedData = jsQR(data, width, height);
        this.decodedData = decodedData.data;
        // document.querySelector("#temp").appendChild(canvas);
      };
      // document.querySelector("#temp").appendChild(qrImage);
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
      // console.log(jsQR(data, width, height));
    });
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.decode-box #data {
  color: rgb(37, 162, 219);
  font-size: 40px;
}
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
