<template>
  <v-container>
    <v-row>
      <template v-if="rooms">
        <template v-for="(room, index) in rooms">
          <v-col
            md="4"
            offset-md="4"
            class="room"
            :key="index"
            @click="startChat(room.id, room.friend_id)"
          >
            {{ room.friend_name }}
          </v-col>
        </template>
      </template>
      <v-col v-else>
        <p>Friendがいません</p>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  props: ["id"],
  data() {
    return {
      rooms: null,
    };
  },
  async created() {
    const res = await this.$axios.get("/rooms", this.headers);
    if (res.data[0]) this.rooms = res.data;
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    async startChat(roomId, friendId) {
      if (!roomId) {
        const formData = new FormData();
        formData.append("band_room[band_id]", friendId);
        const res = await this.$axios.post("/rooms", formData, this.headers);
        roomId = res.data;
      }
      this.$router.push(`/bands/${this.id}/chats/${roomId}`);
    },
  },
};
</script>

<style>
.room {
  cursor: pointer;
}
</style>
