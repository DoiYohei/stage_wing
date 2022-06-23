<template>
  <v-card-actions>
    <v-menu>
      <template v-slot:activator="{ on, attrs }">
        <v-btn icon v-bind="attrs" v-on="on">
          <v-icon>mdi-dots-horizontal</v-icon>
        </v-btn>
      </template>
      <v-card-text class="pa-0">
        <v-list dense class="py-0" color="grey darken-3">
          <v-list-item-group>
            <v-list-item :to="`/events/${eventId}/edit`">
              Eventを編集する
            </v-list-item>
            <v-dialog v-model="dialog" width="360">
              <template #activator="{ on, attrs }">
                <v-list-item v-bind="attrs" v-on="on">
                  Eventを削除する
                </v-list-item>
              </template>
              <DialogYesNo
                dialogText="このイベントを削除しますか？"
                @select-excution="deleteEvent"
                @close-dialog="closeDialog"
              />
            </v-dialog>
            <v-list-item :to="`/events/${eventId}/lineup/edit`">
              Lineupを編集する
            </v-list-item>
          </v-list-item-group>
        </v-list>
      </v-card-text>
    </v-menu>
  </v-card-actions>
</template>

<script>
import DialogYesNo from "@/components/Dialogs/DialogYesNo";

export default {
  components: {
    DialogYesNo,
  },
  props: {
    eventId: {
      type: Number,
      require: true,
    },
  },
  data() {
    return {
      dialog: false,
    };
  },
  methods: {
    deleteEvent() {
      this.$emit("delete-event");
      this.closeDialog();
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
