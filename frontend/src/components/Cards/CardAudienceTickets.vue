<template>
  <v-col xl="8" md="12" sm="8">
    <v-card>
      <v-row v-if="event.ticket" align="center" no-gutters>
        <v-col lg="7">
          <v-card-text>チケットを取り置きしています。</v-card-text>
        </v-col>
        <v-col>
          <v-dialog v-model="dialog" width="45vw">
            <template #activator="{ on, attrs }">
              <v-card-actions>
                <v-btn v-bind="attrs" v-on="on" small>キャンセルする</v-btn>
              </v-card-actions>
            </template>
            <CardDialog
              dialogText="このイベントのチケットをキャンセルしますか？"
              :select-excution="requestDeleteTicket"
              :select-cancel="closeDialog"
            />
          </v-dialog>
        </v-col>
      </v-row>
      <TheTicketsNew
        v-if="!event.ticket && event.reservation"
        :event="event"
        :post-ticket="postTicket"
      />
      <v-card-text v-if="!event.ticket && !event.reservation">
        チケット取り置きはできません
      </v-card-text>
    </v-card>
  </v-col>
</template>

<script>
import CardDialog from "@/components/Cards/CardDialog";
import TheTicketsNew from "@/components/TheTicketsNew";

export default {
  components: {
    CardDialog,
    TheTicketsNew,
  },
  props: {
    event: {
      type: Object,
      require: true,
    },
    postTicket: {
      type: Function,
      require: true,
    },
    deleteTicket: {
      type: Function,
      require: true,
    },
  },
  data() {
    return {
      dialog: false,
    };
  },
  methods: {
    requestDeleteTicket() {
      this.deleteTicket();
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
