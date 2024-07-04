import { createLocalVue, mount } from "@vue/test-utils";
import VueRouter from "vue-router";
import CardAvatar from "@/components/Cards/CardAvatar";

const localVue = createLocalVue();
localVue.use(VueRouter);

describe("CardAvatar.vue", () => {
  let wrapper;
  let router;

  beforeEach(() => {
    router = new VueRouter();
    wrapper = mount(CardAvatar, {
      localVue,
      router,
      propsData: {
        avatar: {
          image: {
            url: "",
          },
          name: "name",
          id: 1,
        },
        userType: "bands",
      },
    });
  });

  context("when userType is 'bands'", () => {
    it("has link to band page", () => {
      expect(wrapper.find("a").attributes().href).toBe("#/bands/1");
    });
  });

  context("when userType is 'audiences'", () => {
    beforeEach(() => {
      wrapper.setProps({ userType: "audiences" });
    });

    it("does not have link", () => {
      expect(wrapper.find("a").exists()).toBe(false);
    });
  });
});
