module.exports = {
  transpileDependencies: ["vuetify"],
  configureWebpack: {
    performance: {
      maxAssetSize: 8000000,
      maxEntrypointSize: 1400000,
    }
  }
};
