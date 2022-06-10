<template>
  <v-dialog v-model="dialog" width="450px">
    <template #activator="{ on, attrs }">
      <v-btn v-bind="attrs" v-on="on" color="grey lighten-2" light small>
        チケットを取り置きする
      </v-btn>
    </template>
    <v-card outlined>
      <v-col>
        <v-card flat class="text-left">
          <ValidationObserver v-slot="{ handleSubmit }">
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
            <ValidationProvider
              name="お目当てのバンド"
              rules="required"
              v-slot="{ errors }"
            >
              <v-card-actions>
                <v-select
                  v-model="bandId"
                  :error-messages="errors"
                  :items="event.performers"
                  item-text="name"
                  item-value="id"
                  label="お目当てのバンド"
                  placeholder="選択してください"
                  dense
                  outlined
                  persistent-placeholder
                />
              </v-card-actions>
            </ValidationProvider>
            <v-card-actions>
              <v-spacer />
              <v-btn
                @click="handleSubmit(postTicket)"
                color="grey darken-3"
                width="100"
              >
                完了
              </v-btn>
              <v-btn @click="closeDialog" color="grey darken-3" width="100">
                キャンセル
              </v-btn>
              <v-spacer />
            </v-card-actions>
          </ValidationObserver>
        </v-card>
      </v-col>
    </v-card>
  </v-dialog>
</template>

<script>
import { ValidationProvider, ValidationObserver } from "vee-validate";

export default {
  components: {
    ValidationProvider,
    ValidationObserver,
  },
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
      this.closeDialog();
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
