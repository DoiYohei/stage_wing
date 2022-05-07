module.exports = {
  presets: [
    [
      "@babel/preset-env",
      {
        targets: {
          node: true
        }
      },
    ],
  ],
  env: {
    test: {
      presets: [
        [
          "@babel/preset-env",
          {
            targets: {
              node: "current",
            },
          },
        ],
      ],
    },
  },
}
