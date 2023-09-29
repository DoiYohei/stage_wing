import { createLocalVue, mount } from "@vue/test-utils";
import Vuetify from "vuetify";
import FormAuth from "@/components/Forms/FormAuth";

const localVue = createLocalVue();
localVue.use(Vuetify);

describe("FormAuth.vue", () => {
  let vuetify;
  let wrapper;

  beforeEach(() => {
    vuetify = new Vuetify();
    const $route = {
      name: "Signup",
      path: "/signup",
    };
    wrapper = mount(FormAuth, {
      localVue,
      vuetify,
      propsData: { value: {} },
      mocks: {
        $route,
      },
    });
  });
  
  context("when current route is '/signup'", () => {
    it("has 'Sign Up' submit button", () => {
      expect(wrapper.text()).toContain("Sign Up");
      expect(wrapper.text()).not.toContain("Log In");
    });

    it("has InputImage, InputName, InputEmail and InputPassword components", () => {
      expect(wrapper.find("[data-jest='input-img']").exists()).toBe(true);
      expect(wrapper.find("[data-jest='input-name']").exists()).toBe(true);
      expect(wrapper.find("[data-jest='input-email']").exists()).toBe(true);
      expect(wrapper.find("[data-jest='input-password']").exists()).toBe(true);
    });

    context("when user is band", () => {
      beforeEach(() => {
        wrapper.setProps({
          value: {
            nameLabel: "Band Name",
          },
        });
      });
      
      it("passes max='50' porps to InputName component", () => {
        expect(wrapper.find("[data-jest='input-name']").props().max).toBe("50");
      });
    });
    
    context("when user is audience", () => {
      beforeEach(() => {
        wrapper.setProps({
          value: {
            nameLabel: "Name",
          },
        });
      });
      
      it("passes max='10' porps to InputName component", () => {
        expect(wrapper.find("[data-jest='input-name']").props().max).toBe("10");
      });
    });
  });

  context("when current route is '/login'", () => {
    beforeEach(() => {
      wrapper.vm.$route.name = "Login";
      wrapper.vm.$route.path = "/login";
    });

    it("has 'Log In' submit button", () => {
      expect(wrapper.text()).toContain("Log In");
      expect(wrapper.text()).not.toContain("Sign Up");
    });

    it("has only InputEmail and InputPassword components", () => {
      expect(wrapper.find("[data-jest='input-img']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='input-name']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='input-email']").exists()).toBe(true);
      expect(wrapper.find("[data-jest='input-password']").exists()).toBe(true);
    });
  });
});

