<template>
  <v-container>
    <template v-if="!isLoading">
      <v-row>
        <v-col>
          <v-card>
            <v-col class="d-flex justify-md-start flex-wrap">
              <v-col md="7" sm="12">
                <v-img :src="event.flyer" />
              </v-col>
              <v-col class="text-left pb-0">
                <div class="d-flex">
                  <v-card-title>{{ event.name }}</v-card-title>
                  <v-card-actions v-if="isEventOwner">
                    <v-menu>
                      <template v-slot:activator="{ on, attrs }">
                        <v-btn icon v-bind="attrs" v-on="on">
                          <v-icon>mdi-dots-horizontal</v-icon>
                        </v-btn>
                      </template>
                      <v-card-text class="pa-0">
                        <v-list>
                          <v-list-item-group>
                            <v-list-item :to="`/events/${id}/edit`">
                              Eventを編集する
                            </v-list-item>
                            <v-dialog v-model="dialog" width="45vw">
                              <template v-slot:activator="{ on, attrs }">
                                <v-list-item v-bind="attrs" v-on="on">
                                  Eventを削除する
                                </v-list-item>
                              </template>
                              <v-card class="py-10">
                                <v-card-text>
                                  このEventを削除しますか？
                                </v-card-text>
                                <v-card-actions class="d-fex justify-center">
                                  <v-btn @click="deleteEvent" class="mx-2">
                                    はい
                                  </v-btn>
                                  <v-btn @click="dialog = false" class="mx-2">
                                    いいえ
                                  </v-btn>
                                </v-card-actions>
                              </v-card>
                            </v-dialog>
                            <v-list-item :to="`/events/${id}/lineup/edit`">
                              Lineupを編集する
                            </v-list-item>
                          </v-list-item-group>
                        </v-list>
                      </v-card-text>
                    </v-menu>
                  </v-card-actions>
                </div>
                <v-card-text>
                  <div>
                    Date:
                    {{ $dayjs(event.open_at).format("YYYY MMM DD") }}
                  </div>
                  <div>
                    Open/Start:
                    {{ $dayjs(event.open_at).format("hh:mm") }}/{{
                      $dayjs(event.start_at).format("hh:mm")
                    }}
                  </div>
                  <div>Location: {{ event.place }}</div>
                  <div>Ticket: ¥{{ event.ticket_price }}</div>
                </v-card-text>
                <v-card-text class="pt-0">
                  {{ event.content }}
                </v-card-text>
                <v-col>
                  <v-card tile outlined>
                    <v-card-subtitle>Lineup</v-card-subtitle>
                    <v-card-text>
                      <v-breadcrumbs
                        :items="lineups"
                        divider="/"
                        class="pt-0"
                      />
                    </v-card-text>
                  </v-card>
                </v-col>
                <v-col v-if="isAudience" xl="8" md="12" sm="8">
                  <v-card>
                    <v-row v-if="event.ticket" align="center" no-gutters>
                      <v-col lg="7">
                        <v-card-text>
                          チケットを取り置きしています。
                        </v-card-text>
                      </v-col>
                      <v-col>
                        <v-dialog v-model="dialog" width="45vw">
                          <template v-slot:activator="{ on, attrs }">
                            <v-card-actions>
                              <v-btn v-bind="attrs" v-on="on" small>
                                キャンセルする
                              </v-btn>
                            </v-card-actions>
                          </template>
                          <v-card class="py-10">
                            <v-card-text>
                              このイベントのチケットをキャンセルしますか？
                            </v-card-text>
                            <v-card-actions class="d-flex justify-center">
                              <v-btn @click="deleteTicket" class="mx-2">
                                はい
                              </v-btn>
                              <v-btn @click="dialog = false" class="mx-2">
                                いいえ
                              </v-btn>
                            </v-card-actions>
                          </v-card>
                        </v-dialog>
                      </v-col>
                    </v-row>
                    <v-card-text v-else-if="event.reservation">
                      <router-link :to="`/events/${id}/tickets/new`"
                        >チケットを取り置きする
                      </router-link>
                    </v-card-text>
                    <v-card-text v-else>
                      チケット取り置きはできません
                    </v-card-text>
                  </v-card>
                </v-col>
                <v-col class="d-flex justify-end">
                  <v-card flat class="d-flex align-center">
                    <v-card-subtitle class="px-2">created by:</v-card-subtitle>
                    <router-link
                      :to="`/bands/${event.owner.id}`"
                      v-if="event.owner"
                      class="d-flex align-center"
                    >
                      <v-img :src="event.owner.image" class="rounded-circle" />
                      <v-card-subtitle class="pl-1 pr-0">
                        {{ event.owner.name }}
                      </v-card-subtitle>
                    </router-link>
                    <v-card-subtitle v-else class="px-0">
                      作成者は退会しました
                    </v-card-subtitle>
                  </v-card>
                </v-col>
              </v-col>
            </v-col>
          </v-card>
        </v-col>
      </v-row>
      <template v-for="(comment, index) of event.parent_comments">
        <CommentForEvent :comment="comment" :key="`comment${index}`" />
      </template>
      <v-col md="4" offset-md="4">
        <v-textarea v-model="newComment" label="コメント" outlined />
        <v-col cols="12">
          <v-btn elevation="4" @click="postComment">コメントする</v-btn>
        </v-col>
      </v-col>
    </template>
  </v-container>
</template>

<script>
import CommentForEvent from "@/components/CommentForEvent";

export default {
  components: {
    CommentForEvent,
  },
  props: ["id"],
  data() {
    return {
      event: null,
      bands: null,
      eventOwner: {},
      newComment: "",
      lineups: [],
      dialog: false,
    };
  },
  async created() {
    let token = null;
    if (this.isAudience) {
      token = { headers: this.$store.getters.token };
    }
    const res = await this.$store.dispatch("getEventData", {
      eventId: this.id,
      token,
    });
    this.event = res;
    for (let performer of this.event.performers) {
      this.lineups.push({
        text: performer.name,
        to: `/bands/${performer.id}`,
      });
    }
    if (this.event.unregistered_performers) {
      const unregisters = this.event.unregistered_performers.split("*/");
      for (let unregister of unregisters) {
        this.lineups.push({ text: unregister });
      }
    }
  },
  computed: {
    isLoading() {
      if (this.event) {
        return false;
      } else {
        return true;
      }
    },
    isEventOwner() {
      if (this.event.owner) {
        return (
          this.$store.getters.userType === "band" &&
          this.$store.getters.currentUserId === this.event.owner.id
        );
      } else {
        return false;
      }
    },
    isAudience() {
      return this.$store.getters.userType === "audience";
    },
  },
  methods: {
    async deleteEvent() {
      const token = { headers: this.$store.getters.token };
      await this.$axios.delete(`/events/${this.id}`, token);
      this.$router.replace("/");
    },
    async postComment() {
      if (!this.$store.getters.authData) {
        return this.$router.push("/errors/auth");
      } else {
        const token = { headers: this.$store.getters.token };
        const formData = new FormData();
        formData.append("comment[event_id]", this.id);
        formData.append("comment[content]", this.newComment);
        await this.$axios.post(`/events/${this.id}/comments`, formData, token);
        this.$router.go({ path: this.$router.currentRoute.path, force: true });
      }
    },
    async deleteTicket() {
      const token = { headers: this.$store.getters.token };
      await this.$axios.delete(
        `/events/${this.id}/tickets/${this.event.ticket.id}`,
        token
      );
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
    },
  },
};
</script>
