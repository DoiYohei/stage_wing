export const sliceContentsForShow = (contents, page, rows) => {
  return contents.slice(rows * (page - 1), rows * page);
};
