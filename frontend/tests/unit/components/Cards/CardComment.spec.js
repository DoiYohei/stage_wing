import { createLocalVue, shallowMount } from "@vue/test-utils";
import Vuex from "vuex";
import dayjs from "dayjs";
import CardComment from "@/components/Cards/CardComment";

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.prototype.$dayjs = dayjs;

describe("CardComment.vue", () => {
  let wrapper;
  let store;

  beforeEach(() => {
    store = new Vuex.Store({
      getters: {
        userType: () => "bands",
        userId: () => 1,
      },
    });
    wrapper = shallowMount(CardComment, {
      localVue,
      store,
      propsData: {
        comment: {
          commenter: {
            user_type: "bands",
            id: 1,
          },
        },
      },
    });
  });

  context("when user has same userType and userId with comment owner", () => {
    it("has trush button", () => {
      expect(wrapper.find("[data-jest='trash-btn']").exists()).toBe(true);
    });
  });

  context(
    "when user has same userType and diffenrent userId with comment owner",
    () => {
      beforeEach(() => {
        wrapper.setProps({
          comment: {
            commenter: {
              user_type: "bands",
              id: 2,
            },
          },
        });
      });

      it("has not trush button", () => {
        expect(wrapper.find("[data-jest='trash-btn']").exists()).toBe(false);
      });
    }
  );

  context(
    "when user has diffenrent userType and same userId with comment owner",
    () => {
      beforeEach(() => {
        wrapper.setProps({
          comment: {
            commenter: {
              user_type: "audiences",
              id: 1,
            },
          },
        });
      });

      it("has not trush button", () => {
        expect(wrapper.find("[data-jest='trash-btn']").exists()).toBe(false);
      });
    }
  );
});
