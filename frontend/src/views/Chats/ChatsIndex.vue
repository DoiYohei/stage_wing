<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card
          color="#121212"
          flat
          :class="$vuetify.breakpoint.mdAndUp ? `text-center` : `text-left`"
        >
          <v-card-subtitle>
            チャットをするユーザーを選んでください。（
            チャットは「Friend」のユーザーとのみ可能です。）
          </v-card-subtitle>
          <v-col v-if="rooms" :cols="cols" :offset="offset">
            <v-list class="text-left text-truncate">
              <v-list-item-group>
                <v-list-item
                  v-for="(room, index) in rooms"
                  :key="index"
                  @click="startChat(room.id, room.friend_id)"
                >
                  <v-list-item-avatar>
                    <v-img :src="avatar(room.friend_img)" />
                  </v-list-item-avatar>
                  <v-list-item-content>
                    <v-list-item-title>
                      {{ room.friend_name }}
                    </v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list-item-group>
            </v-list>
          </v-col>
          <v-card-text v-if="!rooms" class="white--text mt-6">
            Friend がいません。
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import { respondCols } from "@/utils/grids";
import { bandImage } from "@/utils/images";
import { goHome } from "@/utils/routers";
import { fetchRooms, goToChatShow } from "@/utils/chats";

export default {
  props: ["id"],
  data() {
    return {
      rooms: null,
    };
  },
  async created() {
    if (Number(this.id) !== this.bandId) {
      return goHome();
    } else {
      try {
        const res = await fetchRooms();
        if (res.data[0]) this.rooms = res.data;
      } catch (error) {
        goHome();
      }
    }
  },
  computed: {
    ...mapGetters(["bandId"]),
    cols() {
      return respondCols(this.$vuetify.breakpoint, 4, 6, 8, 10, 12);
    },
    offset() {
      return respondCols(this.$vuetify.breakpoint, 4, 3, 2, 1, 0);
    },
    avatar() {
      return (image) => bandImage(image);
    },
  },
  methods: {
    async startChat(roomId, partnerId) {
      try {
        goToChatShow(roomId, partnerId);
      } catch (error) {
        this.showResult("チャットを開始できません。");
      }
    },
    ...mapActions(["showResult"]),
  },
};
</script>
