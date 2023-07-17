export const respondCols = (breakpoint, xlc, lgc, mdc, smc, xsc) => {
  const { xl, lg, md, sm } = breakpoint;
  return xl ? xlc : lg ? lgc : md ? mdc : sm ? smc : xsc;
};
