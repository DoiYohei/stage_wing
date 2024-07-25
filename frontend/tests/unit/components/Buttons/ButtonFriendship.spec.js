import { createLocalVue, shallowMount } from "@vue/test-utils";
import Buttonfriendship from "@/components/Buttons/ButtonFriendship";

const localVue = createLocalVue();

describe("ButtonFriendship.vue", () => {
  const commonProps = { band: { id: 1, name: "band1" }, index: 1 };
  const friendProps = { ...commonProps, friendState: "friend" };
  const invitingProps = { ...commonProps, friendState: "inviting" };
  const invitedProps = { ...commonProps, friendState: "invited" };
  const noFriendStateProps = { ...commonProps, friendState: null };
  const shallowMountComponent = (props) => {
    return shallowMount(Buttonfriendship, {
      localVue,
      propsData: props,
    });
  };
  const findStateBtn = (wrapper) => {
    return wrapper.find(`[data-jest="state-btn"]`);
  };
  const findStateText = (wrapper) => {
    return wrapper.find(`[data-jest="state-text"]`);
  };
  const findActionBtn = (wrapper) => {
    return wrapper.find(`[data-jest="action-btn"]`);
  };

  context("when friendState is 'friend'", () => {
    const wrapper = shallowMountComponent(friendProps);
    const stateBtn = findStateBtn(wrapper);
    const stateText = findStateText(wrapper);
    const actionBtn = findActionBtn(wrapper);

    it("has grey lighten-2 FRIEND button", () => {
      expect(stateBtn.attributes().color).toBe("grey lighten-2");
      expect(stateBtn.text()).toBe("FRIEND");
    });
    it("has friend dialog", () => {
      expect(stateText.text()).toBe(
        "FRIENDです。\nFRIENDを解除するとチャットができなくなります。\nまた、チャット履歴も削除されます。"
      );
      expect(actionBtn.text()).toBe("FRIENDを解除する");
    });

    context("when click actionBtn", () => {
      it("emits 'change-friend-state'", () => {
        actionBtn.vm.$emit("click");
        expect(wrapper.emitted("change-friend-state").length).toBe(1);
        expect(wrapper.emitted("change-friend-state")[0][0]).toEqual(
          wrapper.vm.$props.band
        );
        expect(wrapper.emitted("change-friend-state")[0][1].opposition).toEqual(
          "invited"
        );
        expect(
          wrapper.emitted("change-friend-state")[0][1].isFollowing
        ).toEqual(true);
        expect(wrapper.emitted("change-friend-state")[0][2]).toEqual(
          wrapper.vm.$props.index
        );
      });
    });
  });

  context("when friendState is 'inviting'", () => {
    const wrapper = shallowMountComponent(invitingProps);
    const stateBtn = findStateBtn(wrapper);
    const stateText = findStateText(wrapper);
    const actionBtn = findActionBtn(wrapper);

    it("has grey lighten-2 REQUESTING button", () => {
      expect(stateBtn.attributes().color).toBe("grey lighten-2");
      expect(stateBtn.text()).toBe("REQUESTING");
    });
    it("has inviting dialog", () => {
      expect(stateText.text()).toBe(
        "FRIEND申請中です。\n承認されるとチャットができるようになります。"
      );
      expect(actionBtn.text()).toBe("申請を解除する");
    });

    context("when click actionBtn", () => {
      it("emits 'change-friend-state'", () => {
        actionBtn.vm.$emit("click");
        expect(wrapper.emitted("change-friend-state").length).toBe(1);
        expect(wrapper.emitted("change-friend-state")[0][0]).toEqual(
          wrapper.vm.$props.band
        );
        expect(wrapper.emitted("change-friend-state")[0][1].opposition).toEqual(
          null
        );
        expect(
          wrapper.emitted("change-friend-state")[0][1].isFollowing
        ).toEqual(true);
        expect(wrapper.emitted("change-friend-state")[0][2]).toEqual(
          wrapper.vm.$props.index
        );
      });
    });
  });

  context("when friendState is 'invited'", () => {
    const wrapper = shallowMountComponent(invitedProps);
    const stateBtn = findStateBtn(wrapper);
    const stateText = findStateText(wrapper);
    const actionBtn = findActionBtn(wrapper);

    it("has grey darken-2 REQUESTED button", () => {
      expect(stateBtn.attributes().color).toBe("grey darken-2");
      expect(stateBtn.text()).toBe("REQUESTED");
    });
    it("has inviting dialog", () => {
      expect(stateText.text()).toBe(
        "FRIEND申請を受けています。\n承認するとチャットができるようになります。"
      );
      expect(actionBtn.text()).toBe("承認する");
    });

    context("when click actionBtn", () => {
      it("emits 'change-friend-state'", () => {
        actionBtn.vm.$emit("click");
        expect(wrapper.emitted("change-friend-state").length).toBe(1);
        expect(wrapper.emitted("change-friend-state")[0][0]).toEqual(
          wrapper.vm.$props.band
        );
        expect(wrapper.emitted("change-friend-state")[0][1].opposition).toEqual(
          "friend"
        );
        expect(
          wrapper.emitted("change-friend-state")[0][1].isFollowing
        ).toEqual(false);
        expect(wrapper.emitted("change-friend-state")[0][2]).toEqual(
          wrapper.vm.$props.index
        );
      });
    });
  });

  context("when friendState is null", () => {
    const wrapper = shallowMountComponent(noFriendStateProps);
    const stateBtn = findStateBtn(wrapper);
    const stateText = findStateText(wrapper);
    const actionBtn = findActionBtn(wrapper);

    it("has grey darken-2 NOT FRIEND button", () => {
      expect(stateBtn.attributes().color).toBe("grey darken-2");
      expect(stateBtn.text()).toBe("NOT FRIEND");
    });
    it("has inviting dialog", () => {
      expect(stateText.text()).toBe(
        "FRIENDではありません。\nFRIENDになるとチャットができるようになります。"
      );
      expect(actionBtn.text()).toBe("FRIEND申請する");
    });

    context("when click actionBtn", () => {
      it("emits 'change-friend-state'", () => {
        actionBtn.vm.$emit("click");
        expect(wrapper.emitted("change-friend-state").length).toBe(1);
        expect(wrapper.emitted("change-friend-state")[0][0]).toEqual(
          wrapper.vm.$props.band
        );
        expect(wrapper.emitted("change-friend-state")[0][1].opposition).toEqual(
          "inviting"
        );
        expect(
          wrapper.emitted("change-friend-state")[0][1].isFollowing
        ).toEqual(false);
        expect(wrapper.emitted("change-friend-state")[0][2]).toEqual(
          wrapper.vm.$props.index
        );
      });
    });
  });
});
