<template>
  <v-card-actions>
    <v-card color="grey darken-3">
      <v-dialog v-if="event.ticket" v-model="dialog" width="45vw">
        <template #activator="{ on, attrs }">
          <v-card-text v-bind="attrs" v-on="on" class="pa-2">
            チケットを取り置きしています。
          </v-card-text>
        </template>
        <CardDialog
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
    </v-card>
  </v-card-actions>
</template>

<script>
import CardDialog from "@/components/Cards/CardDialog";
import TheEventsTicketsNew from "@/components/TheEvents/TheEventsTicketsNew";

export default {
  components: {
    CardDialog,
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
