<template>
<div>
<el-row>
  <el-button v-on:click="readQrStream">Start</el-button>
  <el-button v-on:click="stopScanning">Stop</el-button>
  <input type="file" accept="image/*;capture=camera" v-on:change="drawImageToCanvasAndScan"/>
  <el-switch
  style="display: block"
 v-model="cameraType"
  active-color="#13ce66"
  inactive-color="#ff4949"
  active-text="Rear"
  inactive-text="Front">
</el-switch>
</el-row>
<el-row>
    <video v-show="canStream" ref="streamPlayer" height="scanConfig.contentViewer.height" width="scanConfig.contentViewer.width"></video>
    <canvas ref="qrCanvas" id="myCanvas" width="200" height="100"></canvas>
</el-row>
<div class="decode-box">
  <span id="data">
  {{decodedData}}
  </span>
  </div>
  

  </div>

</template>

<script>
import qrcode from "qrcode";
import jsQR from "jsqr";

export default {
  name: "QRScanner",
  props: {
    msg: String,
  },
  data() {
    return {
      tracks: 0,
      imageFrame: undefined,
      stream: undefined,
      canStream: false,
      scanIntervalId: undefined,
      decodedData: undefined,
      getFrameInterval: 500,
      scanTimeout: 6000,
      scanConfig: {
        contentViewer: {
          height: 400,
          width: 400,
        },
      },
      cameraType: true,
    };
  },
  watch: {
    canStream: function(oldVal, newVal) {
      if (!newVal) {
        this.scanConfig.contentViewer.width = 0;
        this.scanConfig.contentViewer.height = 0;
        this.imageFrame.track.stop();
        this.stream.getTracks().forEach((t) => t.stop());
        this.$refs.streamPlayer.pause();
        this.$refs.streamPlayer.src = undefined;
      }
    },
  },
  methods: {
    readQrStream() {
      this.canStream = true;
      navigator.mediaDevices
        .getUserMedia({
          audio: false,
          video: {
            facingMode: this.cameraType ? { exact: "environment" } : "user",
          },
        })
        .then((stream) => {
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
            if (this.decodedData == undefined) {
              this.$notify({
                title: "Scan Timeout Exceeded",
                message: "Please Try Again",
              });
            }
          }, this.scanTimeout);
        })
        .catch(console.log);
    },
    getFrame() {
      this.imageFrame
        .takePhoto({ imageHeight: 480, imageWidth: 640 })
        .then(this.scanBlob)
        .then(({ data, chunks, location, binaryData }) => {
          if (this.decodedData == undefined) {
            this.canStream = false;
            this.decodedData = data;
            console.log(`${data}`);
          }
        })
        .catch((error) => console.log(error));
    },
    scanBlob(photoBlob) {
      if (photoBlob instanceof Blob) {
        return new Promise((resolve, reject) => {
          const height = 480,
            width = 640;
          let imageFrame = document.createElement("img");
          imageFrame.src = URL.createObjectURL(photoBlob);
          // document.querySelector("#temp").appendChild(imageFrame);
          let canvas = document.createElement("canvas");
          imageFrame.onload = () => {
            canvas.height = height;
            canvas.width = width;
            let ctx = canvas.getContext("2d");
            ctx.drawImage(imageFrame, 0, 0);
            // document.querySelector("#temp").appendChild(canvas);
            const decodedData = jsQR(
              ctx.getImageData(0, 0, width, height).data,
              width,
              height
            );
            if (decodedData) {
              resolve(decodedData);
            } else {
              reject("Can't Scan");
            }
          };
        });
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
    },
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
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.decode-box #data {
  color: rgb(37, 162, 219);
  font-size: 40px;
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
