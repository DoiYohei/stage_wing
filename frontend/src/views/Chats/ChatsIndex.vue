<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card color="#121212" flat class="text-center">
          <v-card-subtitle>
            チャットをするユーザーを選んでください。（
            チャットは「Friend」のユーザーとのみ可能です。）
          </v-card-subtitle>
          <v-card-actions v-if="rooms">
            <v-spacer />
            <v-list color="#121212">
              <v-list-item-group>
                <v-list-item
                  v-for="(room, index) in rooms"
                  :key="index"
                  @click="startChat(room.id, room.friend_id)"
                >
                  <ListItemAvatar :image="room.friend_img" />
                  <v-list-item-content>
                    <v-list-item-title>
                      {{ room.friend_name }}
                    </v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list-item-group>
            </v-list>
            <v-spacer />
          </v-card-actions>
          <v-card-text v-if="!rooms" class="white--text mt-6">
            Friend がいません。
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import ListItemAvatar from "@/components/ListItemAvatar";

export default {
  components: {
    ListItemAvatar,
  },
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
