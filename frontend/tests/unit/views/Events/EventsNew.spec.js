import { createLocalVue, shallowMount } from '@vue/test-utils';
import Vuetify from 'vuetify';
import VueRouter from "vue-router";
import * as lineupUtils from '@/utils/lineup';
import EventsNew from '@/views/Events/EventsNew.vue';

const localVue = createLocalVue();
localVue.use(VueRouter);

jest.mock('@/utils/events', () => {
  return { postEvent: jest.fn(() => {
    return { data: { id: 1} };
  }) };
});

describe("EventsNew.vue", () => {
  let vuetify;
  let wrapper;

  beforeEach(async () => {
    vuetify = new Vuetify();
    const router = new VueRouter();
    await router.push("/events/new");
    wrapper = shallowMount(EventsNew, {
      localVue,
      vuetify,
      router,
    });
  });

  describe("pushLineup method", () => {
    context("when user inputs a band", () => {
      beforeEach(() => {
        wrapper.setData({
          lineup: {
            newLineup: [{ name: "test1" }],
            newNoIdLineup: [],
          },
        });
      });
      it("reflects the inputed band in the lineup for display", () => {
        expect(wrapper.vm.allLineup).toEqual("");
        wrapper.vm.pushLineup();
        expect(wrapper.vm.allLineup).toEqual("test1");
      });
    });

    context("when user inputs multiple bands", () => {
      beforeEach(() => {
        wrapper.setData({
          lineup: {
            newLineup: [{ name: "test1" }, { name: "test2" }],
            newNoIdLineup: ["test3", "test4"],
          },
        });
      });
      it("reflects the inputed bands in the lineup for display", () => {
        expect(wrapper.vm.allLineup).toEqual("");
        wrapper.vm.pushLineup();
        expect(wrapper.vm.allLineup).toEqual("test1 / test2 / test3 / test4");
      });
    });
  });

  describe("postEvent method", () => {
    beforeEach(() => {
      wrapper.setData({
        lineup : {
          newLineup: [{ name: "test1" }],
          newNoIdLineup: [],
        },
      });
    });

    context("when post lineup is successful", () => {
      beforeEach(() => {
        jest.spyOn(lineupUtils, "postLineup").mockImplementation(() => {});
      });
      it("goes to the event page with no error", async () => {
        expect(wrapper.vm.$router.currentRoute.path).toEqual("/events/new");
        await wrapper.vm.postEvent();
        expect(wrapper.vm.$route.path).toEqual("/events/1");
        expect(wrapper.vm.$route.query.lineupCreateError).toBeFalsy();
      });
    });

    context("when post lineup is failed", () => {
      beforeEach(() => {
        jest.spyOn(lineupUtils, "postLineup").mockImplementation(() => {
          throw new Error("error");
        });
      });
      it("goes to the event page with error", async () => {
        expect(wrapper.vm.$router.currentRoute.path).toEqual("/events/new");
        await wrapper.vm.postEvent();
        expect(wrapper.vm.$route.path).toEqual("/events/1");
        expect(wrapper.vm.$route.query.lineupCreateError).toBeTruthy();
      });
    });
  });
});
