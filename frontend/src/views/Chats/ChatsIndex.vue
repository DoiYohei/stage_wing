<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card flat>
          <v-card-subtitle>
            チャットをするユーザーを選んでください。
            （チャットは「Friend」のユーザーとのみ可能です。）
          </v-card-subtitle>
          <v-card-actions v-if="rooms">
            <v-spacer />
            <v-list>
              <v-list-item-group>
                <v-list-item
                  v-for="(room, index) in rooms"
                  :key="index"
                  @click="startChat(room.id, room.friend_id)"
                >
                  <v-list-item-avatar>
                    <v-img :src="room.friend_img" />
                  </v-list-item-avatar>
                  <v-list-item-content>
                    <v-list-item-title class="text-left">
                      {{ room.friend_name }}
                    </v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list-item-group>
            </v-list>
            <v-spacer />
          </v-card-actions>
          <v-card-text v-if="!rooms">Friendがいません。</v-card-text>
        </v-card>
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
      this.$router.push({
        path: `/bands/${this.id}/chats/${roomId}`,
        query: { partnerId: friendId },
      });
    },
  },
};
</script>
