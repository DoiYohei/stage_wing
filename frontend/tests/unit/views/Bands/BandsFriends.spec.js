import { createLocalVue, shallowMount } from "@vue/test-utils";
import { goHome } from "@/utils/routers";
import { changeFriendship } from "@/utils/friendships";
import Vuex from "vuex";
import Vuetify from "vuetify";
import BandsFriends from "@/views/Bands/BandsFriends";

const friends = [
  {
    id: 2,
    friend_state: "friend",
  },
  {
    id: 3,
    friend_state: "friend",
  },
];
const invitees = [
  {
    id: 4,
    friend_state: "inviting",
  },
  {
    id: 5,
    friend_state: "inviting",
  },
];
const inviters = [
  {
    id: 6,
    friend_state: "invited",
  },
  {
    id: 7,
    friend_state: "invited",
  },
];
const axiosGetMock = jest.fn(() => Promise.resolve({
  data:  {
    friends,
    invitees,
    inviters,
  },
}));
jest.mock("@/utils/routers", () => {
  return { goHome: jest.fn() };
});
jest.mock("@/utils/friendships", () => {
  return { changeFriendship: jest.fn() };
});
afterEach(() => {
  goHome.mockClear();
  changeFriendship.mockClear();
  axiosGetMock.mockClear();
});

const propsData = { id: 1 };
const localVue = createLocalVue();
localVue.use(Vuex);

describe("BandsFriends.vue", () => {
  let store;
  let getters;
  let vuetify;
  let wrapper;

  context("when user is not this page owner", () => {
    beforeEach(() => {
      getters = {
        bandId: () => 2,
        headers: () => "headers",
      };
      store = new Vuex.Store({
        getters,
      });
      vuetify = new Vuetify();
      wrapper = shallowMount(BandsFriends, {
        localVue,
        store,
        vuetify,
        propsData,
        mocks: {
          $axios: {
            get: axiosGetMock,
          },
        },
      });
    });

    it("goes home page", () => {
      expect(goHome).toHaveBeenCalled();
      expect(axiosGetMock).not.toHaveBeenCalled();
    });
  });

  context("when user is this page owner", () => {
    beforeEach(() => {
      getters = {
        bandId: () => 1,
        headers: () => "headers",
      };
      store = new Vuex.Store({
        getters,
      });
      vuetify = new Vuetify();
      wrapper = shallowMount(BandsFriends, {
        localVue,
        store,
        vuetify,
        propsData,
        mocks: {
          $axios: {
            get: axiosGetMock,
          },
        },
      });
    });

    it("renders this page", () => {
      expect(goHome).not.toHaveBeenCalled();
      expect(axiosGetMock).toHaveBeenCalled();
      expect(wrapper.vm.statesOfFriends).toEqual(["friend", "friend"]);
      expect(wrapper.vm.statesOfInvitees).toEqual(["inviting", "inviting"]);
      expect(wrapper.vm.statesOfInviters).toEqual(["invited", "invited"]);
    });
  });

  describe("Regarding changeFriendState method", () => {
    context("when the other band is friend", () => {
      const band = friends[0];
      const friendship = {
        opposition: "invited",
      };
      const index = 0;
      it("changes to inviter", () => {
        expect(wrapper.vm.statesOfFriends).toEqual(["friend", "friend"]);
        wrapper.vm.changeFriendState(band, friendship, index);
        expect(wrapper.vm.statesOfFriends).toEqual(["invited", "friend"]);
      });
    });

    context("when the other band is invitee", () => {
      const band = invitees[1];
      const friendship = {
        opposition: null,
      };
      const index = 1;
      it("changes to not friend", () => {
        expect(wrapper.vm.statesOfInvitees).toEqual(["inviting", "inviting"]);
        wrapper.vm.changeFriendState(band, friendship, index);
        expect(wrapper.vm.statesOfInvitees).toEqual(["inviting", null]);
      });
    });
    context("when the other band is inviter", () => {
      const band = inviters[0];
      const friendship = {
        opposition: "friend",
      };
      const index = 0;
      it("changes to friend", () => {
        expect(wrapper.vm.statesOfInviters).toEqual(["invited", "invited"]);
        wrapper.vm.changeFriendState(band, friendship, index);
        expect(wrapper.vm.statesOfInviters).toEqual(["friend", "invited"]);
      });
    });
    context("when the other band is not friend", () => {
      const band = invitees[1];
      const friendship = {
        opposition: "inviting",
      };
      const index = 1;
      it("changes to inviting", () => {
        expect(wrapper.vm.statesOfInvitees).toEqual(["inviting", null]);
        wrapper.vm.changeFriendState(band, friendship, index);
        expect(wrapper.vm.statesOfInvitees).toEqual(["inviting", "inviting"]);
      });
    });
  });
});
