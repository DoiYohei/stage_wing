import { createLocalVue, mount } from "@vue/test-utils";
import Vuetify from "vuetify";
import VueRouter from "vue-router";
import Vuex from "vuex";
import VueYouTube from "vue-youtube";
import dayjs from "dayjs";
import CardPost from "@/components/Cards/CardPost";

const localVue = createLocalVue();
localVue.use(Vuetify);
localVue.use(VueRouter);
localVue.use(Vuex);
localVue.use(VueYouTube);
localVue.prototype.$dayjs = dayjs;

describe("CardPost.vue", () => {
  let vuetify;
  let router;
  let state;
  let getters;
  let store;
  let wrapper;
  const testBand = {
    id: 1,
    image: {
      url: "bandUrl",
    },
  };

  beforeEach(() => {
    vuetify = new Vuetify();
    router = new VueRouter();
    state = {
      bandId: null,
    };
    getters = {
      bandId: (state) => state.bandId,
    };
    store = new Vuex.Store({
      state,
      getters,
    });
    wrapper = mount(CardPost, {
      localVue,
      vuetify,
      router,
      store,
      propsData: { post : { band: testBand } },
    });
  });

  context("when user is post owner", () => {
    beforeEach(() => {
      store.state.bandId = 1;
    });

    it("has button to open owner menu", () => {
      expect(wrapper.find("[data-jest='menu-btn']").exists()).toBe(true);
    });
  });

  context("when user is not post owner", () => {
    beforeEach(() => {
      store.state.bandId = 2;
    });

    it("has not button to open owner menu", () => {
      expect(wrapper.find("[data-jest='menu-btn']").exists()).toBe(false);
    });
  });

  context("when post format is 'text'", () => {
    beforeEach(() => {
      wrapper.setProps({
        post: {
          format: "text",
          band: testBand,
        },
      });
    });

    it("hasn't photo, audio and embed player", () => {
      expect(wrapper.find("[data-jest='photo']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='audio']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='soundcloud']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='youtube']").exists()).toBe(false);
    });
  });

  context("when post format is 'photo'", () => {
    beforeEach(() => {
      wrapper.setProps({
        post: {
          format: "photo",
          photo: {
            url: "photoUrl",
          },
          band: testBand,
        },
      })
    });

    it("has photo and hasn't audio and embed player", () => {
      expect(wrapper.find("[data-jest='photo']").exists()).toBe(true);
      expect(wrapper.find("[data-jest='audio']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='soundcloud']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='youtube']").exists()).toBe(false);
    });
  });

  context("when post format is 'audio'", () => {
    beforeEach(() => {
      wrapper.setProps({
        post: {
          format: "audio",
          audio: {
            url: "audioUrl",
          },
          band: testBand,
        },
      })
    });

    it("has audio and hasn't photo and embed player", () => {
      expect(wrapper.find("[data-jest='photo']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='audio']").exists()).toBe(true);
      expect(wrapper.find("[data-jest='soundcloud']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='youtube']").exists()).toBe(false);
    });
  });

  context("when post format is 'soundcloud'", () => {
    beforeEach(() => {
      wrapper.setProps({
        post: {
          format: "soundcloud",
          band: testBand,
        },
      })
    });

    it("has soundcloud and hasn't photo, audio and youtube", () => {
      expect(wrapper.find("[data-jest='photo']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='audio']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='soundcloud']").exists()).toBe(true);
      expect(wrapper.find("[data-jest='youtube']").exists()).toBe(false);
    });
  });

  context("when post format is 'youtube'", () => {
    beforeEach(() => {
      wrapper.setProps({
        post: {
          format: "youtube",
          band: testBand,
        },
      })
    });

    it("has youtube and hasn't photo, audio and soundcloud", () => {
      expect(wrapper.find("[data-jest='photo']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='audio']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='soundcloud']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='youtube']").exists()).toBe(true);
    });
  });
});

