import { shallowMount } from "@vue/test-utils";
import TheEventsComment from "@/components/TheEvents/TheEventsComment";

describe("TheEventsComment.vue", () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(TheEventsComment, {
      propsData: {
        comment: {
          id: 1,
          content: "parent comment",
          created_at: "2021-01-01T00:00:00.000Z",
          parent_id: null,
          commenter: {
            id: 1,
            name: "audience1",
            image: {
              url: "",
            },
            user_type: "audiences",
          },
          replies: [],
        },
      },
    });
  });

  context("when comment has no replies", () => {
    it("has no reply comments card", () => {
      expect(wrapper.find("[data-jest='reply']").exists()).toBe(false);
    });
  });

  context("when comment has replies", () => {
    beforeEach(() => {
      wrapper.setProps({
        comment: {
          id: 1,
          content: "parent comment",
          created_at: "2021-01-01T00:00:00.000Z",
          parent_id: null,
          commenter: {
            id: 1,
            name: "audience1",
            image: {
              url: "",
            },
            user_type: "audiences",
          },
          replies: [
            {
              id: 2,
              content: "child comment1",
              created_at: "2021-01-01T00:00:00.000Z",
              parent_id: 1,
              commenter: {
                id: 2,
                name: "audience2",
                image: {
                  url: "",
                },
                user_type: "audiences",
              },
            },
            {
              id: 3,
              content: "child comment2",
              created_at: "2021-01-01T00:00:00.000Z",
              parent_id: 1,
              commenter: {
                id: 3,
                name: "audience3",
                image: {
                  url: "",
                },
                user_type: "audiences",
              },
            },
          ],
        },
      });
    });

    it("has all replies in reply comments card", () => {
      expect(wrapper.findAll("[data-jest='reply']").length).toBe(2);
    });
  });
});
