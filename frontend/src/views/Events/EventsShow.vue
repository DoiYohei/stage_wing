<template>
  <v-container :fluid="$vuetify.breakpoint.lgAndDown">
    <v-row>
      <v-col>
        <v-card class="d-flex flex-wrap">
          <v-col md="7" cols="12" class="pa-0">
            <v-img :src="eventFlyer" aspect-ratio="1.25" />
          </v-col>
          <v-col md="5" class="text-left pb-0 px-0 px-md-3 pt-1 pt-md-3">
            <v-card flat>
              <v-tabs v-model="tab" grow>
                <v-tab>Detail</v-tab>
                <v-tab>Comment</v-tab>
              </v-tabs>
            </v-card>
            <v-tabs-items v-model="tab" class="my-2 my-md-3 my-lg-4">
              <v-tab-item>
                <TheEventsDetail
                  :event="event"
                  :lineup-for-show="lineupForShow"
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
                  text-for-submit="更新する"
                  text-for-clear="キャンセル"
                />
              </v-tab-item>
              <v-tab-item>
                <v-card flat>
                  <FormComment
                    v-model="newComment"
                    btn-text="送信"
                    label="新規コメント"
                    @submit-form="postComment"
                    class="pb-0"
                  />
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
import TheEventsDetail from "@/components/TheEvents/TheEventsDetail";
import DialogLineupForm from "@/components/Dialogs/DialogLineupForm";
import FormComment from "@/components/Forms/FormComment";
import TheEventsComment from "@/components/TheEvents/TheEventsComment";
import { mapActions } from "vuex";
import { goTo404 } from "@/utils/routers";
import { eventFlyer } from "@/utils/images";
import { getEvent, deleteEvent } from "@/utils/events";
import { postComment, deleteComment } from "@/utils/comments";
import { postTicket, deleteTicket } from "@/utils/tickets";
import { setLineupForShow, patchLineup } from "@/utils/lineup";

export default {
  components: {
    TheEventsDetail,
    DialogLineupForm,
    FormComment,
    TheEventsComment,
  },
  props: ["id"],
  data() {
    return {
      event: {},
      lineupForShow: [], // 表示用Lineup
      lineup: {
        // 編集用Lineup
        newLineup: [],
        newNoIdLineup: [],
      },
      lineupDialog: false,
      tab: 0,
      newComment: "",
    };
  },
  async created() {
    // Lineup作成or更新処理後このページに遷移してくる。
    // Lineup作成or更新でエラーがあった場合、このページでメッセージを表示する。
    if (this.$route.query.lineupCreateError) {
      this.showError("Lineup作成に失敗しました。");
      this.$router.replace({ query: {} });
    }
    if (this.$route.query.lineupUpdateError) {
      this.showError("Lineup更新に失敗しました。");
      this.$router.replace({ query: {} });
    }

    try {
      this.event = await getEvent(this.id);
      this.setLineupForEdit();
      this.lineupForShow = setLineupForShow(this.event);
    } catch (error) {
      goTo404();
    }
  },
  computed: {
    eventFlyer() {
      return eventFlyer(this.event.flyer);
    },
  },
  methods: {
    deleteEvent() {
      deleteEvent(this.id);
    },
    postComment(newReply, parentId) {
      postComment(newReply, parentId, this.newComment, this.id);
    },
    deleteComment(commentId) {
      deleteComment(commentId);
    },
    postTicket(bandId) {
      postTicket(this.id, bandId);
    },
    deleteTicket() {
      deleteTicket(this.event.ticket.id);
    },
    patchLineup() {
      patchLineup(this.event, this.lineup);
    },
    openLineupDialog() {
      this.lineupDialog = true;
    },
    closeLineupDialog() {
      this.setLineupForEdit();
      this.lineupDialog = false;
    },
    setLineupForEdit() {
      this.lineup.newLineup = [...this.event.performers];
      this.lineup.newNoIdLineup = [...this.event.unregistered_performers];
    },
    ...mapActions(["showError"]),
  },
};
</script>
