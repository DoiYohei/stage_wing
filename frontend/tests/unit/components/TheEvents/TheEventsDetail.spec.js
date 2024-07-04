import { createLocalVue, shallowMount } from "@vue/test-utils";
import Vuex from "vuex";
import dayjs from "dayjs";
import TheEventsDetail from "@/components/TheEvents/TheEventsDetail";

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.prototype.$dayjs = dayjs;

describe("TheEventsDetail.vue", () => {
  let state;
  let getters;
  let store;
  let wrapper;

  beforeEach(() => {
    state = {
      bandId: null,
      audienceId: null,
    };
    getters = {
      bandId: (state) => state.bandId,
      audienceId: (state) => state.audienceId,
    };
    store = new Vuex.Store({
      state,
      getters,
    });
    wrapper = shallowMount(TheEventsDetail, {
      localVue,
      store,
      propsData: {
        event: {
          id: 1,
          owner: {
            id: 1,
          },
          place: "test place",
          open_at: "2020-01-01T00:00:00.000+09:00",
          start_at: "2020-01-01T00:30:00.000+09:00",
          ticket_price: 1000,
          date: "2020-01-01",
          reservation: true,
        },
      },
    });
  });

  context(
    "when event has place, open_at, start_at, ticket_price and date",
    () => {
      it("renders correct format", () => {
        expect(wrapper.html()).toContain("Location: test place");
        expect(wrapper.html()).toContain("Open/Start: 00:00/00:30");
        expect(wrapper.html()).toContain("Ticket: ¥ 1000");
        expect(wrapper.html()).toContain("Date: 2020年01月01日");
      });
    }
  );

  context(
    "when event does't have place, open_at, start_at and ticket_price",
    () => {
      beforeEach(() => {
        wrapper.setProps({
          event: {
            id: 1,
            place: "",
            open_at: null,
            start_at: null,
            ticket_price: null,
          },
        });
      });

      it("renders '未定'", () => {
        expect(wrapper.html()).toContain("Location: 未定");
        expect(wrapper.html()).toContain("Open/Start: 未定");
        expect(wrapper.html()).toContain("Ticket: 未定");
      });
    }
  );

  context("when event has open_at and does not have start_at", () => {
    beforeEach(() => {
      wrapper.setProps({
        event: {
          id: 1,
          open_at: "2020-01-01T00:00:00.000+09:00",
          start_at: null,
        },
      });
    });

    it("renders only Open", () => {
      expect(wrapper.html()).toContain("Open: 00:00");
      expect(wrapper.html()).not.toContain("Start");
    });
  });

  context("when event has start_at and does not have open_at", () => {
    beforeEach(() => {
      wrapper.setProps({
        event: {
          id: 1,
          open_at: null,
          start_at: "2020-01-01T00:30:00.000+09:00",
        },
      });
    });

    it("renders only Start", () => {
      expect(wrapper.html()).not.toContain("Open");
      expect(wrapper.html()).toContain("Start: 00:30");
    });
  });

  context("when event owner has currently band account", () => {
    it("has owner's avatar card", () => {
      expect(wrapper.find("[data-jest='owner-avatar']").exists()).toBe(true);
      expect(wrapper.html()).not.toContain("作成者は退会しました");
    });
  });

  context("when event owner has already withdrawn band account", () => {
    beforeEach(() => {
      wrapper.setProps({
        event: {
          id: 1,
        },
      });
    });

    it("renders '作成者は退会しました'", () => {
      expect(wrapper.find("[data-jest='owner-avatar']").exists()).toBe(false);
      expect(wrapper.html()).toContain("作成者は退会しました");
    });
  });

  context("when user is not event owner", () => {
    it("does not have owner menu", () => {
      expect(wrapper.find("[data-jest='owner-menu']").exists()).toBe(false);
    });
  });

  context("when user is event owner", () => {
    beforeEach(() => {
      store.state.bandId = 1;
    });

    it("has owner menu", () => {
      expect(wrapper.find("[data-jest='owner-menu']").exists()).toBe(true);
    });
  });

  context("when user is not audience", () => {
    it("does not have ticket button", () => {
      expect(wrapper.find("[data-jest='ticket-cancel']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='ticket-new']").exists()).toBe(false);
    });
  });

  context("when user is audience", () => {
    beforeEach(() => {
      store.state.audienceId = 1;
    });

    context("when user does not have ticket", () => {
      it("does not have ticket cancel button and has ticket new button", () => {
        expect(wrapper.find("[data-jest='ticket-cancel']").exists()).toBe(
          false
        );
        expect(wrapper.find("[data-jest='ticket-new']").exists()).toBe(true);
      });
    });

    context("when user has ticket", () => {
      beforeEach(() => {
        wrapper.setProps({
          event: {
            id: 1,
            owner: {
              id: 1,
            },
            reservation: true,
            ticket: {
              id: 1,
            },
          },
        });
      });

      it("has ticket cancel button and does not have ticket new button", () => {
        expect(wrapper.find("[data-jest='ticket-cancel']").exists()).toBe(true);
        expect(wrapper.find("[data-jest='ticket-new']").exists()).toBe(false);
      });
    });

    context("when ticket reservaitons can't be made", () => {
      beforeEach(() => {
        wrapper.setProps({
          event: {
            id: 1,
            owner: {
              id: 1,
            },
            reservation: false,
          },
        });
      });

      it("does not have ticket button", () => {
        expect(wrapper.find("[data-jest='ticket-cancel']").exists()).toBe(
          false
        );
        expect(wrapper.find("[data-jest='ticket-new']").exists()).toBe(false);
      });
    });
  });
});
