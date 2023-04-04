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
                  :lineupToShow="lineupToShow"
                  @delete-event="deleteEvent"
                  @post-ticket="postTicket"
                  @delete-ticket="deleteTicket"
                  @open-lineup-dialog="openLineupDialog"
                />
                <DialogLineupForm
                  v-model="lineup"
                  :dialog="lineupDialog"
                  @select-submit="patchLineup"
                  @select-clear="closeLineupDialog"
                >
                  <template #submit-text>更新する</template>
                  <template #clear-text>キャンセル</template>
                </DialogLineupForm>
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
import DialogLineupForm from "@/components/Dialogs/DialogLineupForm";
import DialogShowText from "@/components/Dialogs/DialogShowText";
import FormComment from "@/components/Forms/FormComment";
import TheEventsComment from "@/components/TheEvents/TheEventsComment";

export default {
  components: {
    TheEventsDetail,
    DialogLineupForm,
    DialogShowText,
    FormComment,
    TheEventsComment,
  },
  props: ["id"],
  data() {
    return {
      event: {},
      lineupToShow: [],
      originalLineup: [],
      noIdLineup: [],
      lineup: {
        newLineup: [],
        newNoIdLineup: [],
      },
      tab: 0,
      newComment: "",
      lineupDialog: false,
      isError: false,
      errorText: "",
    };
  },
  async created() {
    // Lineup作成処理後このページに遷移してくる
    // Lineup作成でエラーがあった場合、このページでメッセージを表示
    this.showError(
      this.$route.query.lineupCreateError,
      "Lineup作成に失敗しました。"
    );

    try {
      // Event情報取得
      // ユーザーがAudienceの場合はTicket取り置き状況も取得
      const audienceToken = this.audienceId ? this.headers : null;
      const res = await this.$axios.get(`/events/${this.id}`, audienceToken);
      this.event = res.data;

      // 取得したEventのLineupを編集フォーム用に整形
      if (this.event.unregistered_performers) {
        this.noIdLineup = this.event.unregistered_performers.split("*/");
      }
      this.lineup.newNoIdLineup = [...this.noIdLineup];
      this.originalLineup = this.event.performers;
      this.lineup.newLineup = [...this.originalLineup];

      // Lineupを表示用に整形
      for (let originalBand of this.originalLineup) {
        this.lineupToShow.push({
          text: originalBand.name,
          to: `/bands/${originalBand.id}`,
        });
      }
      if (this.noIdLineup) {
        for (let noIdBand of this.noIdLineup) {
          this.lineupToShow.push({ text: noIdBand });
        }
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
      if (!newValue && this.lineupDialog) this.updatePage();
      if (!newValue) {
        this.errorText = "";
        this.$router.push({ query: {} });
      }
    },
  },
  methods: {
    showError(error, text) {
      if (error) {
        this.isError = true;
        this.errorText = text;
      }
    },
    async deleteEvent() {
      try {
        await this.$axios.delete(`/events/${this.id}`, this.headers);
        this.$router.replace("/");
      } catch (error) {
        this.showError(error.response, "イベントを削除できませんでした。");
      }
    },
    async postComment(newReply, parentId) {
      if (!this.token) {
        return this.$router.push("/errors/unauthorized");
      } else {
        try {
          const formData = new FormData();
          if (newReply) {
            formData.append("comment[content]", newReply);
            formData.append("comment[parent_id", parentId);
          } else {
            formData.append("comment[content]", this.newComment);
          }
          formData.append("comment[event_id]", this.id);
          await this.$axios.post("/comments", formData, this.headers);
          this.updatePage();
        } catch (error) {
          this.showError(error.response, "コメントを投稿できませんでした。");
        }
      }
    },
    async deleteComment(commentId) {
      try {
        await this.$axios.delete(`/comments/${commentId}`, this.headers);
        this.updatePage();
      } catch (error) {
        this.showError(error.response, "コメントを削除できませんでした。");
      }
    },
    async postTicket(bandId) {
      try {
        const formData = new FormData();
        formData.append("ticket[event_id]", this.id);
        formData.append("ticket[band_id]", bandId);
        await this.$axios.post(`/tickets`, formData, this.headers);
        this.updatePage();
      } catch (error) {
        this.showError(error.response, "チケットを取り置きできませんでした。");
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
        this.showError(
          error.response,
          "チケットをキャンセルできませんでした。"
        );
      }
    },
    async patchLineup() {
      try {
        // 本サービスに登録されていないBandは、Eventsテーブルで更新する
        const eventFormData = new FormData();
        eventFormData.append(
          "event[unregistered_performers]",
          this.lineup.newNoIdLineup.join("*/")
        );
        await this.$axios.patch(
          `/events/${this.id}`,
          eventFormData,
          this.headers
        );

        // 本サービスに登録されているBandは、Lineupテーブルで更新する
        // 新しいLineupで元のLineupにいないBandはPOSTする
        const lineupToPost = this.lineup.newLineup.filter((newBand) => {
          return (
            this.originalLineup.filter((originalBand) => {
              return newBand.id === originalBand.id;
            }).length === 0
          );
        });
        if (lineupToPost) {
          for (let bandToPost of lineupToPost) {
            const lineupFormData = new FormData();
            lineupFormData.append("lineup[event_id]", this.id);
            lineupFormData.append("lineup[performer_id]", bandToPost.id);
            await this.$axios.post(
              `/events/${this.id}/lineups`,
              lineupFormData,
              this.headers
            );
          }
        }
        // 元のLineupで新しいLineupにいないBandはDELETEする
        const lineupToDelete = this.originalLineup.filter((originalBand) => {
          return (
            this.lineup.newLineup.filter((newBand) => {
              return originalBand.id === newBand.id;
            }).length === 0
          );
        });
        if (lineupToDelete) {
          for (let bandToDelete of lineupToDelete) {
            const lineupFormData = new FormData();
            lineupFormData.append("lineup[event_id]", this.id);
            lineupFormData.append("lineup[performer_id]", bandToDelete.id);
            await this.$axios.delete(`/events/${this.id}/lineups`, {
              headers: this.token,
              data: lineupFormData,
            });
          }
        }
        this.updatePage();
      } catch (error) {
        this.showError(error.response, "Lineup更新に失敗しました。");
      }
    },
    updatePage() {
      this.$router.go({
        path: this.$router.currentRoute.path,
        force: true,
      });
    },
    closeLineupDialog() {
      this.lineup.newLineup = [...this.originalLineup];
      this.lineup.newNoIdLineup = [...this.noIdLineup];
      this.lineupDialog = false;
    },
    openLineupDialog() {
      this.lineupDialog = true;
    },
  },
};
</script>
