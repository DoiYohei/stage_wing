<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card class="d-flex flex-wrap">
          <v-col md="7" cols="12" class="pa-0">
            <v-img :src="eventFlyer" aspect-ratio="1.25" />
          </v-col>
          <v-col md="5" class="text-left pb-0">
            <v-card flat>
              <v-tabs v-model="tab" fixed-tabs>
                <v-tab>Detail</v-tab>
                <v-tab>Comment</v-tab>
              </v-tabs>
            </v-card>
            <v-tabs-items v-model="tab" class="my-5">
              <v-tab-item>
                <TheEventsDetail
                  :event="event"
                  :lineups="lineups"
                  @delete-event="deleteEvent"
                  @post-ticket="postTicket"
                  @delete-ticket="deleteTicket"
                />
                <DialogShowText v-model="isError">
                  {{ errorText }}
                </DialogShowText>
              </v-tab-item>
              <v-tab-item>
                <v-card flat>
                  <FormComment
                    v-model="newComment"
                    label="新規コメント"
                    @submit-form="postComment"
                    class="pb-0"
                  >
                    送信
                  </FormComment>
                  <v-divider v-if="event.comments && event.comments.length" />
                  <TheEventsComment
                    v-for="(comment, index) of event.comments"
                    :key="index"
                    :comment="comment"
                    @post-comment="postComment"
                    @delete-comment="deleteComment"
                    class="pt-2 pb-0 pl-5"
                  />
                </v-card>
              </v-tab-item>
            </v-tabs-items>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import TheEventsDetail from "@/components/TheEvents/TheEventsDetail";
import DialogShowText from "@/components/Dialogs/DialogShowText";
import FormComment from "@/components/Forms/FormComment";
import TheEventsComment from "@/components/TheEvents/TheEventsComment";

export default {
  components: {
    TheEventsDetail,
    DialogShowText,
    FormComment,
    TheEventsComment,
  },
  props: ["id"],
  data() {
    return {
      event: {},
      lineups: [],
      tab: 0,
      newComment: "",
      isError: false,
      errorText: "",
    };
  },
  async created() {
    try {
      const audienceToken = this.audienceId ? this.headers : null;
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
      const query = this.$route.query;
      if (query.lineupCreateError) {
        this.isError = true;
        this.errorText = "Lineupに登録できないBandがありました。";
      }
      if (query.lineupUpdateError) {
        this.isError = true;
        this.errorText = "Lineupに更新できないBandがありました。";
      }
    } catch (error) {
      if (error.response) this.$router.replace("/errors/not_found");
    }
  },
  computed: {
    ...mapGetters(["audienceId", "headers", "token"]),
    eventFlyer() {
      return this.event.flyer
        ? this.event.flyer
        : require("@/assets/img/no-flyer.jpg");
    },
  },
  watch: {
    isError(newValue) {
      if (!newValue) {
        this.errorText = "";
        if (this.$router.query) this.$router.replace({ query: {} });
      }
    },
  },
  methods: {
    async deleteEvent() {
      try {
        await this.$axios.delete(`/events/${this.id}`, this.headers);
        this.$router.replace("/");
      } catch (error) {
        if (error.response) {
          this.isError = true;
          this.errorText = "イベントを削除できませんでした";
        }
      }
    },
    async postComment(newReply, parentId) {
      if (!this.token) {
        return this.$router.push("/errors/unauthorized");
      } else {
        const formData = new FormData();
        if (newReply) {
          formData.append("comment[content]", newReply);
          formData.append("comment[parent_id", parentId);
        } else {
          formData.append("comment[content]", this.newComment);
        }
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
    async postTicket(bandId) {
      try {
        const formData = new FormData();
        formData.append("ticket[event_id]", this.id);
        formData.append("ticket[band_id]", bandId);
        await this.$axios.post(`/tickets`, formData, this.headers);
        this.updatePage();
      } catch (error) {
        if (error.response) {
          this.isError = true;
          this.errorText = "チケットを取り置きできませんでした。";
        }
      }
    },
    async deleteTicket() {
      try {
        await this.$axios.delete(
          `/tickets/${this.event.ticket.id}`,
          this.headers
        );
        this.updatePage();
      } catch (error) {
        if (error.response) {
          this.isError = true;
          this.errorText = "チケットをキャンセルできませんでした。";
        }
      }
    },
    updatePage() {
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
    },
  },
};
</script>
