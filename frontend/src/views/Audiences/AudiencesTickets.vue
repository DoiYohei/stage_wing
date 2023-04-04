<template>
  <v-container>
    <v-row>
      <v-col xl="8" offset-xl="2">
        <v-card>
          <v-card-title class="font-weight-bold pb-0">
            取り置きしているチケット
          </v-card-title>
          <CardActionsEventPastSelect v-model="showPast" class="pl-3" />
          <v-data-table
            :headers="table_headers"
            :items="displayTickets"
            hide-default-footer
          >
            <template #[`item.event.name`]="{ item }">
              <router-link :to="`/events/${item.event.id}`">
                {{ item.event.name }}
              </router-link>
            </template>
            <template #[`item.band.name`]="{ item }">
              <router-link :to="`/bands/${item.band.id}`">
                {{ item.band.name }}
              </router-link>
            </template>
            <template #[`item.delete`]="{ item }">
              <v-icon @click="openDialog(item)">mdi-delete</v-icon>
            </template>
          </v-data-table>
          <v-dialog v-model="dialog" width="45vw">
            <DialogYesNo
              :dialog-text="dialogText"
              @select-excution="deleteTicket"
              @close-dialog="closeDialog"
            />
          </v-dialog>
          <DialogShowText v-model="isError">
            チケットをキャンセルできませんでした。
          </DialogShowText>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import CardActionsEventPastSelect from "@/components/CardActions/CardActionsEventPastSelect";
import DialogYesNo from "@/components/Dialogs/DialogYesNo";
import DialogShowText from "@/components/Dialogs/DialogShowText";

export default {
  components: {
    CardActionsEventPastSelect,
    DialogYesNo,
    DialogShowText,
  },
  props: ["id"],
  data() {
    return {
      table_headers: [
        {
          text: "Date",
          value: "event.date",
        },
        {
          text: "Event",
          value: "event.name",
        },
        {
          text: "Band",
          value: "band.name",
        },
        {
          text: "",
          value: "delete",
          sortable: false,
        },
      ],
      displayTickets: [],
      futureTickets: [],
      allTickets: [],
      selectedTicket: {},
      showPast: false,
      dialog: false,
      isError: false,
    };
  },
  async created() {
    try {
      if (Number(this.id) !== this.audienceId) throw { response: "status 401" };
      const res = await this.$axios.get(
        `/audiences/${this.id}/tickets`,
        this.headers
      );
      this.allTickets = res.data;

      // 今日開催のEventのTicketはfutureTicketsに含める
      const now = new Date();
      const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      this.futureEvents = this.allTickets.filter((ticket) => {
        return today.getTime() <= new Date(ticket.event.date).getTime();
      });
      this.setDisplayTickets();
    } catch (error) {
      if (error.response) this.$router.replace("/");
    }
  },
  computed: {
    ...mapGetters(["audienceId", "headers"]),
    dialogText() {
      const event = this.selectedTicket.event;
      return event ? `${event.name}のチケット取り置きをやめますか？` : "";
    },
  },
  watch: {
    showPast() {
      this.displayTickets = [];
      this.setDisplayTickets();
    },
  },
  methods: {
    setDisplayTickets() {
      if (this.showPast) {
        for (let ticket of this.allTickets) {
          ticket.event.date = this.$dayjs(ticket.event.date).format(
            "YYYY年MM月DD日"
          );
          this.displayTickets.push(ticket);
        }
      } else {
        for (let ticket of this.futureTickets) {
          ticket.event.date = this.$dayjs(ticket.event.date).format(
            "YYYY年MM月DD日"
          );
          this.displayTickets.push(ticket);
        }
      }
    },
    async deleteTicket() {
      try {
        await this.$axios.delete(
          `/tickets/${this.selectedTicket.id}`,
          this.headers
        );
        this.$router.go({ path: this.$router.currentRoute.path, force: true });
      } catch (error) {
        if (error.response) {
          this.closeDialog();
          this.isError = true;
        }
      }
    },
    openDialog(item) {
      this.selectedTicket = item;
      this.dialog = true;
    },
    closeDialog() {
      this.selectedTicket = "";
      this.dialog = false;
    },
  },
};
</script>
