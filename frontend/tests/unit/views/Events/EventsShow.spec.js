import { createLocalVue, shallowMount } from "@vue/test-utils";
import Vuex from "vuex";
import VueRouter from "vue-router";
import Vuetify from "vuetify";
import EventsShow from "@/views/Events/EventsShow";

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(VueRouter);

jest.mock("@/utils/events", () => {
  return { getEvent: jest.fn(() => {
    return { data: { flyer: "" } };
  }) };
});
jest.mock("@/utils/routers", () => {
  return { goTo404: jest.fn() };
});

describe("EventsShow.vue", () => {
  let wrapper;
  let store;
  let actions;
  let vuetify;

  beforeEach(() => {
    actions = {
      showError: jest.fn(),
    };
    store = new Vuex.Store({
      actions,
    });
  });

  context("when there is a lineup create error", () => {
    beforeEach(async () => {
      const router = new VueRouter();
      await router.push({
        path: "/events/1",
        query: {
          lineupCreateError: "true",
        },
      })
      vuetify = new Vuetify();
      wrapper = shallowMount(EventsShow, {
        localVue,
        store,
        router,
        vuetify,
      });
    });

    it("shows a lineup create error message", () => {
      expect(actions.showError).toHaveBeenCalledWith(expect.any(Object), "Lineup作成に失敗しました。");
      expect(wrapper.vm.$route.query).toEqual({});
    });
  });

  context("when there is a lineup update error", () => {
    beforeEach(async () => {
      const router = new VueRouter();
      await router.push({
        path: "/events/1",
        query: {
          lineupUpdateError: "true",
        },
      })
      vuetify = new Vuetify();
      wrapper = shallowMount(EventsShow, {
        localVue,
        store,
        router,
        vuetify,
      });
    });

    it("shows a lineup update error message", () => {
      expect(actions.showError).toHaveBeenCalledWith(expect.any(Object), "Lineup更新に失敗しました。");
      expect(wrapper.vm.$route.query).toEqual({});
    });
  });

  context("when there is no error", () => {
    beforeEach(async () => {
      const router = new VueRouter();
      await router.push("/events/1");
      vuetify = new Vuetify();
      wrapper = shallowMount(EventsShow, {
        localVue,
        store,
        router,
        vuetify,
      });
    });

    it("doesn't show any error message", () => {
      expect(actions.showError).not.toHaveBeenCalled();
    });
  });
});
