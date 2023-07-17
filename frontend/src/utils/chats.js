import axios from "@/plugins/axios";
import store from "@/store";
import router from "@/routes";

export const fetchRooms = async () => {
  return await axios.get(
    `/bands/${store.getters.bandId}/rooms`,
    store.getters.headers
  );
};

export const findPartnerRoom = (rooms, partnerId) => {
  return rooms.find((room) => room.friend_id === partnerId);
};

export const goToChatShow = async (roomId, partnerId) => {
  // Room未作成の場合は、Room作成後にChatShowページに行く。
  if (!roomId) {
    const formData = new FormData();
    formData.append("band_room[band_id]", partnerId);
    const res = await axios.post("/rooms", formData, store.getters.headers);
    roomId = res.data;
  }
  return router.push({
    path: `/bands/${store.getters.bandId}/chats/${roomId}`,
    query: { partnerId: partnerId },
  });
};
