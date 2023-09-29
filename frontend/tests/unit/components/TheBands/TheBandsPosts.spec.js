import { shallowMount } from "@vue/test-utils";
import TheBandsPosts from "@/components/TheBands/TheBandsPosts";

describe("TheBandsPosts.vue", () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(TheBandsPosts, {
      propsData: {
        posts: [{id: 1}],
        isMyPage: false,
      },
    });
  });

  context("when user is not these posts owner", () => {
    it("has not button for new post", () => {
      expect(wrapper.find("[data-jest='new-post-btn']").exists()).toBe(false);
    });
  });

  context("when user is these posts owner", () => {
    beforeEach(() => {
      wrapper.setProps({
        isMyPage: true,
      });
    });

    it("has button for new post", () => {
      expect(wrapper.find("[data-jest='new-post-btn']").exists()).toBe(true);
    });
  });
});
