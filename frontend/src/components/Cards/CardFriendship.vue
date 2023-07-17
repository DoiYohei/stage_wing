<template>
  <v-card flat>
    <v-toolbar v-if="title" flat>
      <v-toolbar-items v-if="$vuetify.breakpoint.xs">
        <v-btn @click="backwardTab" icon>
          <v-icon>mdi-chevron-left</v-icon>
        </v-btn>
      </v-toolbar-items>
      <v-spacer />
      <v-toolbar-title class="text-subtitle-1 font-weight-black">{{
        title
      }}</v-toolbar-title>
      <v-spacer />
      <v-toolbar-items v-if="$vuetify.breakpoint.xs">
        <v-btn @click="forwardTab" icon>
          <v-icon>mdi-chevron-right</v-icon>
        </v-btn>
      </v-toolbar-items>
    </v-toolbar>
    <v-list>
      <v-list-item v-for="(band, index) in bands" :key="index">
        <v-list-item-content>
          <CardAvatar :avatar="band" userType="bands" />
        </v-list-item-content>
        <v-list-item-action v-if="states[index] === 'friend'">
          <v-btn @click="startChat(band.id)" icon>
            <v-icon>mdi-email-outline</v-icon>
          </v-btn>
        </v-list-item-action>
        <v-list-item-action>
          <ButtonFriendship
            :band="band"
            :index="index"
            :friend-state="states[index]"
            @change-friend-state="changeFriendState"
          />
        </v-list-item-action>
      </v-list-item>
    </v-list>
  </v-card>
</template>

<script>
import CardAvatar from "@/components/Cards/CardAvatar";
import ButtonFriendship from "@/components/Buttons/ButtonFriendship";

export default {
  components: {
    CardAvatar,
    ButtonFriendship,
  },
  props: {
    bands: {
      type: Array,
      require: true,
    },
    states: {
      type: Array,
      require: true,
    },
    title: {
      type: String,
      default: "",
    },
    value: {
      type: Number,
      default: null,
    },
  },
  computed: {
    tab: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
  methods: {
    forwardTab() {
      return (this.tab = this.tab === 2 ? 0 : this.tab + 1);
    },
    backwardTab() {
      return (this.tab = this.tab === 0 ? 2 : this.tab - 1);
    },
    startChat(bandId) {
      this.$emit("start-chat", bandId);
    },
    changeFriendState(band, friendship, index) {
      this.$emit("change-friend-state", band, friendship, index);
    },
  },
};
</script>
