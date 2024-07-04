<template>
  <v-card flat>
    <v-card flat class="d-flex align-start grey--text text--lighten-2">
      <v-card-title>{{ event.name }}</v-card-title>
      <v-card-actions v-if="isEventOwner" data-jest="owner-menu" class="pt-4">
        <v-menu>
          <template v-slot:activator="{ on, attrs }">
            <v-btn icon v-bind="attrs" v-on="on">
              <v-icon>mdi-dots-vertical</v-icon>
            </v-btn>
          </template>
          <v-card color="grey darken-3" width="145">
            <v-card-text class="pa-0">
              <v-list dense class="py-0" color="grey darken-3">
                <v-list-item-group>
                  <v-list-item :to="`/events/${event.id}/edit`">
                    Eventを編集する
                  </v-list-item>
                  <v-list-item @click.stop="eventDialog = true">
                    Eventを削除する
                  </v-list-item>
                  <DialogYesNo
                    v-model="eventDialog"
                    question="このイベントを削除しますか？"
                    @select-excution="deleteEvent"
                    @close-dialog="closeEventDialog"
                  />
                  <v-list-item @click.stop="openLineupDialog">
                    Lineupを編集する
                  </v-list-item>
                </v-list-item-group>
              </v-list>
            </v-card-text>
          </v-card>
        </v-menu>
      </v-card-actions>
    </v-card>
    <v-card-text class="py-0">{{ eventDate }}</v-card-text>
    <v-card-text class="py-0">{{ eventTime }}</v-card-text>
    <v-card-text class="py-0">{{ eventPlace }}</v-card-text>
    <v-card-text class="py-0">{{ ticketPrice }}</v-card-text>
    <v-card-text v-if="event.content" class="reflect-return py-2">{{
      event.content
    }}</v-card-text>
    <v-col>
      <v-card tile outlined style="border-color: #b1b1b1">
        <v-card-subtitle>Lineup</v-card-subtitle>
        <v-card-text>
          <v-breadcrumbs :items="lineupForShow" divider="/" class="pt-0" />
        </v-card-text>
      </v-card>
    </v-col>
    <v-card-actions v-if="audienceId" class="pl-3">
      <v-btn
        v-if="event.ticket"
        @click.stop="ticketDialog = true"
        color="grey darken-2"
        small
        data-jest="ticket-cancel"
      >
        チケットを取り置きしています。
      </v-btn>
      <DialogYesNo
        v-model="ticketDialog"
        question="このイベントのチケットをキャンセルしますか？"
        @select-excution="deleteTicket"
        @close-dialog="closeTicketDialog"
      />
      <TheEventsTicketsNew
        v-if="!event.ticket && event.reservation"
        :event="event"
        :date="eventDate"
        :time="eventTime"
        :place="eventPlace"
        :price="ticketPrice"
        @post-ticket="postTicket"
        data-jest="ticket-new"
      />
    </v-card-actions>
    <v-card-subtitle class="d-flex align-center justify-end">
      created by:
      <CardAvatar
        v-if="event.owner"
        :avatar="event.owner"
        max-width="175"
        userType="bands"
        data-jest="owner-avatar"
        class="ml-2"
      />
      <template v-if="!event.owner">作成者は退会しました</template>
    </v-card-subtitle>
  </v-card>
</template>

<script>
import TheEventsTicketsNew from "@/components/TheEvents/TheEventsTicketsNew";
import DialogYesNo from "@/components/Dialogs/DialogYesNo";
import CardAvatar from "@/components/Cards/CardAvatar";
import { mapGetters } from "vuex";

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
    lineupForShow: {
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
      return this.bandId === this.event.owner?.id;
    },
    eventDate() {
      return `Date: ${this.$dayjs(this.event.date).format("YYYY年MM月DD日")}`;
    },
    eventTime() {
      if (this.event.open_at && this.event.start_at) {
        return `Open/Start: ${this.formattedOpen}/${this.formattedStart}`;
      } else if (this.event.open_at && !this.event.start_at) {
        return `Open: ${this.formattedOpen}`;
      } else if (!this.event.open_at && this.event.start_at) {
        return `Start: ${this.formattedStart}`;
      } else return "Open/Start: 未定";
    },
    formattedOpen() {
      return this.$dayjs(this.event.open_at).format("HH:mm");
    },
    formattedStart() {
      return this.$dayjs(this.event.start_at).format("HH:mm");
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
