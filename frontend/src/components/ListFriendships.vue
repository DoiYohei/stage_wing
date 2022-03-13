<template>
  <v-col>
    <v-card :flat="$vuetify.breakpoint.mdAndDown">
      <v-list class="px-3">
        <v-subheader v-if="$vuetify.breakpoint.lgAndUp" class="grey lighten-4">
          <v-spacer />
          {{ friendship.header }}
          <v-spacer />
        </v-subheader>
        <template v-for="(band, index) in bands">
          <v-list-item :key="band.id">
            <v-spacer v-if="$vuetify.breakpoint.md || $vuetify.breakpoint.sm" />
            <router-link :to="`/bands/${band.id}`" class="d-flex">
              <v-list-item-avatar>
                <v-img :src="band.image.url" />
              </v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title>
                  {{ band.name }}
                </v-list-item-title>
              </v-list-item-content>
            </router-link>
            <v-spacer />
            <v-list-item-icon v-if="isFriend(index)">
              <v-btn @click="goChat(band.id)" icon>
                <v-icon>mdi-email-outline</v-icon>
              </v-btn>
            </v-list-item-icon>
            <v-list-item-action class="ml-4">
              <v-btn @click="changeStatus(band.id, index)">
                {{ btnText(index) }}
              </v-btn>
            </v-list-item-action>
            <v-spacer v-if="$vuetify.breakpoint.md || $vuetify.breakpoint.sm" />
          </v-list-item>
          <v-divider :key="index" v-if="index !== bands.length - 1" />
        </template>
      </v-list>
    </v-card>
  </v-col>
</template>

<script>
export default {
  props: {
    bands: {
      type: Array,
      require: true,
    },
    friendship: {
      type: Object,
      require: true,
    },
    changeFriendship: {
      type: Function,
      require: true,
    },
    revertFriendship: {
      type: Function,
      require: true,
    },
    startChat: {
      type: Function,
      default: null,
    },
  },
  data() {
    return {
      defaultStatus: [],
    };
  },
  created() {
    this.setStatus();
  },
  computed: {
    isFriend() {
      return (index) => {
        if (this.friendship.status === "Friend") {
          return this.defaultStatus[index];
        } else if (this.friendship.status === "Friend承認") {
          return !this.defaultStatus[index];
        } else {
          return false;
        }
      };
    },
    btnText() {
      return (index) => {
        if (this.defaultStatus[index]) {
          return this.friendship.status;
        } else {
          return this.friendship.oppositeStatus;
        }
      };
    },
  },
  watch: {
    bands() {
      this.setStatus();
    },
  },
  methods: {
    setStatus() {
      for (let n = 0; n < this.bands.length; n++) {
        this.defaultStatus.push(true);
      }
    },
    changeStatus(bandId, index) {
      const formData = new FormData();
      formData.append("followed_id", bandId);
      if (this.defaultStatus[index]) {
        this.changeFriendship(formData);
      } else {
        this.revertFriendship(formData);
      }
      this.$set(this.defaultStatus, index, !this.defaultStatus[index]);
    },
    goChat(bandId) {
      this.startChat(bandId);
    },
  },
};
</script>
