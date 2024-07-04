import { createLocalVue, shallowMount } from "@vue/test-utils";
import Vuetify from "vuetify";
import Auth from "@/views/Auth";

const axiosPostMock = jest.fn(() => Promise.resolve({
  data: {}
}));

describe("Auth.vue", () => {
  const localVue = createLocalVue();
  let wrapper;
  let vuetify;
  let $route;

  context("when path is /signup", () => {
    beforeEach(() => {
      vuetify = new Vuetify();
      $route = {
        path: "/signup",
        name: "Signup",
      };
      wrapper = shallowMount(Auth, {
        localVue,
        vuetify,
        mocks: {
          $route,
          $axios: {
            post: axiosPostMock,
          },
        },
      });
    });
    it("has sign-up page title", () => {
      expect(wrapper.find("[data-jest='page-title']").attributes().title).toBe("アカウント作成");
    });
    context("Regarding submitBand method", () => {
      it("calls axios.post with /bands", () => {
        wrapper.vm.submitBand();
        expect(axiosPostMock).toHaveBeenCalledWith("/bands", expect.any(FormData));
      });
    });
    context("Regarding submitAudience method", () => {
      it("calls axios.post with /audiences", () => {
        wrapper.vm.submitAudience();
        expect(axiosPostMock).toHaveBeenCalledWith("/audiences", expect.any(FormData));
      });
    });
  });

  context("when path is /login", () => {
    beforeEach(() => {
      vuetify = new Vuetify();
      $route = {
        path: "/login",
        name: "Login",
      };
      wrapper = shallowMount(Auth, {
        localVue,
        vuetify,
        mocks: {
          $route,
          $axios: {
            post: axiosPostMock,
          },
        },
      });
    });
    it("has log-in page title", () => {
      expect(wrapper.find("[data-jest='page-title']").attributes().title).toBe("ログイン");
    });
    context("Regarding submitBand method", () => {
      it("calls axios.post with /bands/sign_in", () => {
        wrapper.vm.submitBand();
        expect(axiosPostMock).toHaveBeenCalledWith("/bands/sign_in", expect.any(FormData));
      });
    });
    context("Regarding submitAudience method", () => {
      it("calls axios.post with /audiences/sign_in", () => {
        wrapper.vm.submitAudience();
        expect(axiosPostMock).toHaveBeenCalledWith("/audiences/sign_in", expect.any(FormData));
      });
    });
  });
});
