module.exports = {
  presets: [
    [
      "@babel/preset-env",
      {
        modules: false,
        useBuiltIns: "usage",
        corejs: 3,
        targets: {
          node: true,
        },
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
};
