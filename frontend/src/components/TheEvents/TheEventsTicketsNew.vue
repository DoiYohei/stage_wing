<template>
  <v-dialog v-model="dialog" width="450px">
    <template #activator="{ on, attrs }">
      <v-card-text v-bind="attrs" v-on="on" class="pa-2">
        チケットを取り置きする
      </v-card-text>
    </template>
    <v-card outlined>
      <v-col>
        <v-card flat class="text-left">
          <v-card-title>チケット取り置き</v-card-title>
          <v-spacer />
          <v-card-subtitle class="pb-0">
            以下のEventのチケットをお取り置きいたします。
          </v-card-subtitle>
          <v-card-subtitle class="pt-0">
            お目当てのバンドを選択して、完了をクリックしてください。
          </v-card-subtitle>
          <v-spacer />
          <v-card-text>
            <div>Event: {{ event.name }}</div>
            <div>Date: {{ $dayjs(event.open_at).format("YYYY MMM DD") }}</div>
            <div>
              Open/Start: {{ $dayjs(event.open_at).format("hh:mm") }}/{{
                $dayjs(event.start_at).format("hh:mm")
              }}
            </div>
            <div>Location: {{ event.place }}</div>
            <div>Price: ¥{{ event.ticket_price }}</div>
          </v-card-text>
          <v-card-actions>
            <v-select
              v-model="bandId"
              :items="event.performers"
              item-text="name"
              item-value="id"
              label="お目当てのバンド"
              placeholder="選択してください"
              dense
              outlined
              hide-details
              persistent-placeholder
            />
          </v-card-actions>
          <v-card-actions>
            <v-spacer />
            <v-btn @click="postTicket" color="grey darken-3" width="100">
              完了
            </v-btn>
            <v-btn @click="closeDialog" color="grey darken-3" width="100">
              キャンセル
            </v-btn>
            <v-spacer />
          </v-card-actions>
        </v-card>
      </v-col>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    event: {
      type: Object,
      require: true,
    },
  },
  data() {
    return {
      bandId: null,
      dialog: false,
    };
  },
  methods: {
    postTicket() {
      this.$emit("post-ticket", this.bandId);
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
