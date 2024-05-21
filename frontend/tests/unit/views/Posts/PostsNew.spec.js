import { shallowMount } from '@vue/test-utils';
import Vuetify from 'vuetify';
import PostsNew from '@/views/Posts/PostsNew.vue';

describe("PostsNew.vue", () => {
  let vuetify;
  let wrapper;
  const validSoundcloud = '<iframe width="100%" height="300" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/123456789&color=%23ff5500"></iframe><div style="font-size: 10px; color: #cccccc;"></div>';
  const invalidSoundcloud = '<iframe width="100%" height="300" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com"></iframe><div style="font-size: 10px; color: #cccccc;"></div>';
  const validYoutube = '<iframe width="560" height="315" src="https://www.youtube.com/embed/aA123?si=123abc"></iframe>';
  const invalidYoutube = '<iframe width="560" height="315" src="https://www.youtube.com"></iframe>';

  beforeEach(() => {
    vuetify = new Vuetify();
    wrapper = shallowMount(PostsNew, {
      vuetify,
    });
  });

  describe("isFile computed property", () => {
    context("when content format is photo or audio", () => {
      it("returns true", () => {
        wrapper.setData({ format: "photo" });
        expect(wrapper.vm.isFile).toBe(true);
        wrapper.setData({ format: "audio" });
        expect(wrapper.vm.isFile).toBe(true);
      });
    });
    context("when content format is soundcloud, youtube or text", () => {
      it("returns false", () => {
        wrapper.setData({ format: "soundcloud" });
        expect(wrapper.vm.isFile).toBe(false);
        wrapper.setData({ format: "youtube" });
        expect(wrapper.vm.isFile).toBe(false);
        wrapper.setData({ format: "text" });
        expect(wrapper.vm.isFile).toBe(false);
      });
    });
  });

  describe("isMediaPass computed property", () => {
    context("when content format is soundcloud or youtube", () => {
      it("returns true", () => {
        wrapper.setData({ format: "soundcloud" });
        expect(wrapper.vm.isMediaPass).toBe(true);
        wrapper.setData({ format: "youtube" });
        expect(wrapper.vm.isMediaPass).toBe(true);
      });
    });
    context("when content format is photo, audio or text", () => {
      it("returns false", () => {
        wrapper.setData({ format: "photo" });
        expect(wrapper.vm.isMediaPass).toBe(false);
        wrapper.setData({ format: "audio" });
        expect(wrapper.vm.isMediaPass).toBe(false);
        wrapper.setData({ format: "text" });
        expect(wrapper.vm.isMediaPass).toBe(false);
      });
    });
  });

  describe("mediaPass computed property", () => {
    context("when user inputs a valid soundcloud embedCode", () => {
      beforeEach(() => {
        wrapper.setData({ format: "soundcloud" });
      });
      it("returns a valid mediaPass", () => {
        wrapper.setData({ embedCode: validSoundcloud });
        expect(wrapper.vm.mediaPass).toBe("123456789");
      });
    });
    context("when user inputs an invalid soundcloud embedCode", () => {
      beforeEach(() => {
        wrapper.setData({ format: "soundcloud" });
      });
      it("returns empty string", () => {
        wrapper.setData({ embedCode: invalidSoundcloud })
        expect(wrapper.vm.mediaPass).toBe("");
      });
    });
    context("when user inputs a valid youtube embedCode", () => {
      beforeEach(() => {
        wrapper.setData({ format: "youtube" });
      });
      it("returns a valid mediaPass", () => {
        wrapper.setData({ embedCode: validYoutube });
        expect(wrapper.vm.mediaPass).toBe("aA123");
      });
    });
    context("when user inputs an invalid youtube embedCode", () => {
      beforeEach(() => {
        wrapper.setData({ format: "youtube" });
      });
      it("returns empty string", () => {
        wrapper.setData({ embedCode: invalidYoutube });
        expect(wrapper.vm.mediaPass).toBe("");
      });
    });
  });

  describe("createPost method", () => {
    context("when user inputs an invalid embedCode despite selecting soundcloud", () => {
      beforeEach(() => {
        wrapper.setData({ format: "soundcloud" });
      });
      it("shows error message", () => {
        wrapper.setData({ embedCode: "" });
        wrapper.vm.createPost();
        expect(wrapper.vm.isError).toBe(true);
        wrapper.setData({ embedCode: invalidSoundcloud });
        wrapper.vm.createPost();
        expect(wrapper.vm.isError).toBe(true);
      });
    });
    context("when user inputs an invalid embedCode despite selecting youtube", () => {
      beforeEach(() => {
        wrapper.setData({ format: "youtube" });
      });
      it("shows error message", () => {
        wrapper.setData({ embedCode: "" });
        wrapper.vm.createPost();
        expect(wrapper.vm.isError).toBe(true);
        wrapper.setData({ embedCode: invalidYoutube });
        wrapper.vm.createPost();
        expect(wrapper.vm.isError).toBe(true);
      });
    });
  });
});
