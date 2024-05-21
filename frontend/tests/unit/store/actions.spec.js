import store from "@/store";

describe("autoLogin", () => {
  let testDate;
  beforeEach(() => {
    testDate = new Date();
    store.state.token = null;
    localStorage.removeItem("authDataSW");
  });

  context("when there is no token in localStorage", () => {
    it("doesn't make user log in", () => {
      store.dispatch("autoLogin");
      expect(store.state.token).toBeNull();
      expect(localStorage.getItem("authDataSW")).toBeNull();
    });
  });

  context("when token in localStorage is within valid period", () => {
    beforeEach(() => {
      testDate.setDate(testDate.getDate() + 1);
      const expiry = testDate.getTime() / 1000;
      const authData = { token: { expiry: expiry } };
      localStorage.setItem("authDataSW", JSON.stringify(authData));
    });

    it("makes user log in automatically", () => {
      store.dispatch("autoLogin");
      expect(store.state.token).toBeTruthy();
      expect(localStorage.getItem("authDataSW")).toBeTruthy();
    });
  });

  context("when token in localStorage expires", () => {
    beforeEach(() => {
      testDate.setSeconds(testDate.getSeconds() - 1);
      const expiry = testDate.getTime() / 1000;
      const authData = { token: { expiry: expiry } };
      localStorage.setItem("authDataSW", JSON.stringify(authData));
    });

    it("doesn't make user log in and removes token from localStorage", () => {
      store.dispatch("autoLogin");
      expect(store.state.token).toBeNull();
      expect(localStorage.getItem("authDataSW")).toBeNull();
    });
  });
});
