<template>
  <v-card-actions>
    <v-dialog v-if="event.ticket" v-model="dialog" width="45vw">
      <template #activator="{ on, attrs }">
        <v-btn v-bind="attrs" v-on="on" color="grey darken-2" small>
          チケットを取り置きしています。
        </v-btn>
      </template>
      <DialogYesNo
        dialogText="このイベントのチケットをキャンセルしますか？"
        @select-excution="deleteTicket"
        @close-dialog="closeDialog"
      />
    </v-dialog>
    <TheEventsTicketsNew
      v-if="!event.ticket && event.reservation"
      :event="event"
      @post-ticket="postTicket"
    />
  </v-card-actions>
</template>

<script>
import DialogYesNo from "@/components/Dialogs/DialogYesNo";
import TheEventsTicketsNew from "@/components/TheEvents/TheEventsTicketsNew";

export default {
  components: {
    DialogYesNo,
    TheEventsTicketsNew,
  },
  props: {
    event: {
      type: Object,
      require: true,
    },
  },
  data() {
    return {
      dialog: false,
    };
  },
  methods: {
    deleteTicket() {
      this.$emit("delete-ticket");
      this.closeDialog();
    },
    postTicket(bandId) {
      this.$emit("post-ticket", bandId);
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
