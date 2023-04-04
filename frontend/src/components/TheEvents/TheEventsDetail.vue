<template>
  <v-card flat>
    <v-card flat class="d-flex grey--text text--lighten-2">
      <v-card-title>{{ event.name }}</v-card-title>
      <v-card-actions v-if="isEventOwner">
        <v-menu>
          <template v-slot:activator="{ on, attrs }">
            <v-btn icon v-bind="attrs" v-on="on">
              <v-icon>mdi-dots-horizontal</v-icon>
            </v-btn>
          </template>
          <v-card-text class="pa-0">
            <v-list dense class="py-0" color="grey darken-3">
              <v-list-item-group>
                <v-list-item :to="`/events/${event.id}/edit`">
                  Eventを編集する
                </v-list-item>
                <v-dialog v-model="eventDialog" width="360">
                  <template #activator="{ on, attrs }">
                    <v-list-item v-bind="attrs" v-on="on">
                      Eventを削除する
                    </v-list-item>
                  </template>
                  <DialogYesNo
                    dialogText="このイベントを削除しますか？"
                    @select-excution="deleteEvent"
                    @close-dialog="closeEventDialog"
                  />
                </v-dialog>
                <v-list-item @click.stop="openLineupDialog">
                  Lineupを編集する
                </v-list-item>
              </v-list-item-group>
            </v-list>
          </v-card-text>
        </v-menu>
      </v-card-actions>
    </v-card>
    <v-card-text class="py-0">{{ eventDate }}</v-card-text>
    <v-card-text class="py-0">{{ eventTime }}</v-card-text>
    <v-card-text class="py-0">{{ eventPlace }}</v-card-text>
    <v-card-text class="py-0">{{ ticketPrice }}</v-card-text>
    <v-card-text class="reflect-return">{{ event.content }}</v-card-text>
    <v-col>
      <v-card tile outlined style="border-color: #b1b1b1">
        <v-card-subtitle>Lineup</v-card-subtitle>
        <v-card-text>
          <v-breadcrumbs :items="lineupToShow" divider="/" class="pt-0" />
        </v-card-text>
      </v-card>
    </v-col>
    <v-card-actions v-if="audienceId" class="pl-3">
      <v-dialog v-if="event.ticket" v-model="ticketDialog" width="45vw">
        <template #activator="{ on, attrs }">
          <v-btn v-bind="attrs" v-on="on" color="grey darken-2" small>
            チケットを取り置きしています。
          </v-btn>
        </template>
        <DialogYesNo
          dialogText="このイベントのチケットをキャンセルしますか？"
          @select-excution="deleteTicket"
          @close-dialog="closeTicketDialog"
        />
      </v-dialog>
      <TheEventsTicketsNew
        v-if="!event.ticket && event.reservation"
        :event="event"
        @post-ticket="postTicket"
      />
    </v-card-actions>
    <v-card-subtitle class="d-flex align-center justify-end">
      created by:
      <CardAvatar v-if="event.owner" :avatar="event.owner" class="ml-2" />
      <template v-if="!event.owner">作成者は退会しました</template>
    </v-card-subtitle>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
import TheEventsTicketsNew from "@/components/TheEvents/TheEventsTicketsNew";
import DialogYesNo from "@/components/Dialogs/DialogYesNo";
import CardAvatar from "@/components/Cards/CardAvatar";

export default {
  components: {
    TheEventsTicketsNew,
    DialogYesNo,
    CardAvatar,
  },
  props: {
    event: {
      type: Object,
      require: true,
    },
    lineupToShow: {
      type: Array,
      require: true,
    },
  },
  data() {
    return {
      eventDialog: false,
      ticketDialog: false,
    };
  },
  computed: {
    ...mapGetters(["bandId", "audienceId"]),
    isEventOwner() {
      if (this.event.owner) {
        return this.bandId === this.event.owner.id;
      } else {
        return false;
      }
    },
    formattedOpen() {
      return this.$dayjs(this.event.open_at).format("HH:mm");
    },
    formattedStart() {
      return this.$dayjs(this.event.start_at).format("HH:mm");
    },
    eventDate() {
      return `Date: ${this.$dayjs(this.event.date).format("YYYY年MM月DD日")}`;
    },
    eventTime() {
      if (this.event.open_at && this.event.start_at) {
        return `Open/Start: ${this.formattedOpen}/${this.formattedStart}`;
      } else if (this.event.open_at && !this.event.start_at) {
        return `Open: ${this.formattedOpen}`;
      } else if (!this.event.open_at && this.event.tart_at) {
        return `Start: ${this.formattedStart}`;
      } else return "Open/Start: 未定";
    },
    eventPlace() {
      const place = this.event.place ? this.event.place : "未定";
      return `Location: ${place}`;
    },
    ticketPrice() {
      const price = Number.isInteger(this.event.ticket_price)
        ? "¥ " + this.event.ticket_price
        : "未定";
      return `Ticket: ${price}`;
    },
  },
  methods: {
    deleteEvent() {
      this.$emit("delete-event");
      this.closeEventDialog();
    },
    postTicket(bandId) {
      this.$emit("post-ticket", bandId);
    },
    deleteTicket() {
      this.$emit("delete-ticket");
      this.closeTicketDialog();
    },
    openLineupDialog() {
      this.$emit("open-lineup-dialog");
    },
    closeEventDialog() {
      this.eventDialog = false;
    },
    closeTicketDialog() {
      this.ticketDialog = false;
    },
  },
};
</script>
