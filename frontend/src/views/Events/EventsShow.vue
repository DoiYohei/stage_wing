<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card>
          <v-col class="d-flex justify-md-start flex-wrap">
            <v-col md="7" sm="12">
              <v-img :src="event.flyer" />
            </v-col>
            <v-col class="text-left pb-0">
              <v-card flat>
                <v-tabs v-model="tabs" fixed-tabs>
                  <v-tab>Details</v-tab>
                  <v-tab>Comments</v-tab>
                </v-tabs>
              </v-card>
              <v-tabs-items v-model="tabs" class="my-5">
                <v-tab-item>
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
                                <template #activator="{ on, attrs }">
                                  <v-list-item v-bind="attrs" v-on="on">
                                    Eventを削除する
                                  </v-list-item>
                                </template>
                                <CardDialog
                                  dialogText="このイベントを削除しますか？"
                                  :select-excution="deleteEvent"
                                  :select-cancel="closeDialog"
                                />
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
                  <CardAudienceTickets
                    v-if="isAuthenticatedAudience"
                    :event="event"
                    :post-ticket="postTicket"
                    :delete-ticket="deleteTicket"
                  />
                  <v-col class="d-flex justify-end">
                    <v-card flat class="d-flex align-center">
                      <v-card-subtitle class="px-2">
                        created by:
                      </v-card-subtitle>
                      <router-link
                        :to="`/bands/${event.owner.id}`"
                        v-if="event.owner"
                        class="d-flex align-center"
                      >
                        <v-img
                          :src="event.owner.image"
                          class="rounded-circle"
                        />
                        <v-card-subtitle class="pl-1 pr-0">
                          {{ event.owner.name }}
                        </v-card-subtitle>
                      </router-link>
                      <v-card-subtitle v-else class="px-0">
                        作成者は退会しました
                      </v-card-subtitle>
                    </v-card>
                  </v-col>
                </v-tab-item>
                <v-tab-item>
                  <v-col>
                    <v-card flat>
                      <v-col
                        v-for="(comment, index) of event.comments"
                        :key="index"
                      >
                        <CardComments
                          :comment="comment"
                          :post-comment="postComment"
                          :delete-comment="deleteComment"
                        />
                      </v-col>
                      <v-col>
                        <v-card>
                          <v-card-text class="text-right">
                            <v-textarea
                              v-model="newComment"
                              label="新規コメント"
                              class="mb-3"
                              row-height="6"
                              auto-grow
                              hide-details
                              outlined
                            />
                            <v-btn elevation="4" @click="postComment()">
                              コメントする
                            </v-btn>
                          </v-card-text>
                        </v-card>
                      </v-col>
                    </v-card>
                  </v-col>
                </v-tab-item>
              </v-tabs-items>
            </v-col>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import CardComments from "@/components/Cards/CardComments";
import CardAudienceTickets from "@/components/Cards/CardAudienceTickets";
import CardDialog from "@/components/Cards/CardDialog";

export default {
  components: {
    CardComments,
    CardDialog,
    CardAudienceTickets,
  },
  props: ["id"],
  data() {
    return {
      event: {},
      lineups: [],
      dialog: false,
      tabs: 0,
      newComment: "",
    };
  },
  async created() {
    const audienceToken = this.isAuthenticatedAudience ? this.headers : null;
    const res = await this.$axios.get(`/events/${this.id}`, audienceToken);
    this.event = res.data;
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
    ...mapGetters([
      "headers",
      "userId",
      "token",
      "isAuthenticatedBand",
      "isAuthenticatedAudience",
    ]),
    isEventOwner() {
      if (this.event.owner) {
        return this.isAuthenticatedBand && this.userId === this.event.owner.id;
      } else {
        return false;
      }
    },
  },
  methods: {
    async deleteEvent() {
      await this.$axios.delete(`/events/${this.id}`, this.headers);
      this.$router.replace("/");
    },
    async postComment(newReply, parentId) {
      if (!this.token) {
        return this.$router.push("/errors/auth");
      } else {
        const formData = new FormData();
        // 子コンポーネントから来た返信コメントの場合はそのデータを反映
        if (newReply) {
          this.newComment = newReply;
          formData.append("comment[parent_id", parentId);
        }
        formData.append("comment[content]", this.newComment);
        formData.append("comment[event_id]", this.id);
        await this.$axios.post(
          `/events/${this.id}/comments`,
          formData,
          this.headers
        );
        this.updatePage();
      }
    },
    async deleteComment(commentId) {
      await this.$axios.delete(
        `/events/${this.id}/comments/${commentId}`,
        this.headers
      );
      this.updatePage();
    },
    async postTicket(band) {
      const formData = new FormData();
      formData.append("ticket[event_id]", this.id);
      formData.append("ticket[band_id]", band);
      await this.$axios.post(
        `/events/${this.id}/tickets`,
        formData,
        this.headers
      );
      this.updatePage();
    },
    async deleteTicket() {
      await this.$axios.delete(
        `/events/${this.id}/tickets/${this.event.ticket.id}`,
        this.headers
      );
      this.updatePage();
    },
    updatePage() {
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
