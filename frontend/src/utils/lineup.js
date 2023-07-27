import axios from "@/plugins/axios";
import store from "@/store";
import router from "@/routes";
import { reloadPage } from "@/utils/routers";

export const setLineupForShow = (event) => {
  let lineup = [];
  for (let band of event.performers) {
    lineup.push({
      text: band.name,
      to: `/bands/${band.id}`,
    });
  }
  if (event.unregistered_performers) {
    for (let band of event.unregistered_performers) {
      lineup.push({ text: band });
    }
  }
  return lineup;
};

export const patchLineup = async (event, lineup) => {
  try {
    // 本サービスに登録されていないBandは、Eventsテーブルで更新する。
    const eventFormData = new FormData();
    eventFormData.append(
      "event[unregistered_performers]",
      lineup.newNoIdLineup.join("*/")
    );
    await axios.patch(
      `/events/${event.id}`,
      eventFormData,
      store.getters.headers
    );

    // 本サービスに登録されているBandは、Lineupテーブルで更新する。
    // 新しいLineupで元のLineupにいないBandはPOSTする。
    const lineupForPost = filterLineupForUpdate(
      lineup.newLineup,
      event.performers
    );
    if (lineupForPost) await postLineup(lineupForPost, event.id);
    // 元のLineupで新しいLineupにいないBandはDELETEする。
    const lineupForDelete = filterLineupForUpdate(
      event.performers,
      lineup.newLineup
    );
    if (lineupForDelete) await deleteLineup(lineupForDelete, event.id);
  } catch (error) {
    if (error.response) {
      router.replace({ query: { lineupUpdateError: true } });
    }
  }
  reloadPage();
};

export const filterLineupForUpdate = (lineup, otherLineup) => {
  const lineupForUpdate = lineup.filter((bandOfLineup) => {
    return (
      otherLineup.filter((bandOfOtherLineup) => {
        return bandOfLineup.id === bandOfOtherLineup.id;
      }).length === 0
    );
  });
  return lineupForUpdate;
};

export const postLineup = async (lineup, eventId) => {
  for (let band of lineup) {
    const formData = new FormData();
    formData.append("lineup[event_id]", eventId);
    formData.append("lineup[performer_id]", band.id);
    await axios.post(
      `/events/${eventId}/lineups`,
      formData,
      store.getters.headers
    );
  }
};

export const deleteLineup = async (lineup, eventId) => {
  for (let band of lineup) {
    const formData = new FormData();
    formData.append("lineup[event_id]", eventId);
    formData.append("lineup[performer_id]", band.id);
    await axios.delete(`/events/${eventId}/lineups`, {
      headers: store.getters.token,
      data: formData,
    });
  }
};
