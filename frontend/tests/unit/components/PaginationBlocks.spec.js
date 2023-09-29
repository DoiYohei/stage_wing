import { createLocalVue, mount } from "@vue/test-utils";
import Vuetify from "vuetify";
import PaginationBlocks from "@/components/PaginationBlocks";

const localVue = createLocalVue();
localVue.use(Vuetify);

describe("PaginationBlocks.vue", () => {
  let vuetify;
  let wrapper;

  beforeEach(() => {
    vuetify = new Vuetify();
    wrapper = mount(PaginationBlocks, {
      localVue,
      vuetify,
      propsData: {
        value: 1,
        contents: [],
        rows: 2,
      },
    });
  });

  context("when contents is empty", () => {
    it("isn't rendered", () => {
      expect(wrapper.html()).toBe("");
    });
  });

  context("when contents isn't empty", () => {
    beforeEach(() => {
      wrapper.setProps({
        contents: ["content1", "content2", "content3", "content4", "content5"],
      })
    });

    it("has correct pagination buttons", () => {
      expect(wrapper.find("[aria-label='Previous page']").exists()).toBe(true);
      expect(wrapper.find("[aria-label='Next page']").exists()).toBe(true);
      expect(wrapper.find("[aria-label='Current Page, Page 1']").exists()).toBe(true);
      expect(wrapper.find("[aria-label='Goto Page 2']").exists()).toBe(true);
      expect(wrapper.find("[aria-label='Goto Page 3']").exists()).toBe(true);
      expect(wrapper.find("[aria-label='Goto Page 4']").exists()).toBe(false);
    });
  });
});
