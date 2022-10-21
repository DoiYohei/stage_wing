<template>
  <v-container>
    <v-row class="text-center">
      <v-col cols="12">
        <v-card class="mx-auto my-12" max-width="800">
          <v-card-actions>
            <CardAvatar
              v-if="partner.image"
              :avatar="partner"
              size="50"
              class="font-weight-bold text-h6"
            />
          </v-card-actions>
          <v-divider />
          <v-card-text class="white--text">
            <v-row>
              <v-col cols="12">
                <v-container
                  ref="scrollTarget"
                  style="height: 450px"
                  class="overflow-y-auto"
                >
                  <template v-for="(message, index) in messages">
                    <v-row
                      v-if="isFirstContentInDate(message.id)"
                      :key="message.created_at"
                      dense
                    >
                      <v-col>
                        <v-divider v-if="index !== 0" />
                        <div class="mt-4 font-weight-bold">
                          {{ $dayjs(message.created_at).format("YYYY MMM DD") }}
                        </div>
                      </v-col>
                    </v-row>
                    <v-row :key="index" dense>
                      <v-col v-if="message.band_id !== bandId">
                        <div class="balloon_l">
                          <div class="face_icon">
                            <v-avatar size="40">
                              <v-img :src="bandImage(message.band_image)" />
                            </v-avatar>
                          </div>
                          <p
                            v-text="message.content"
                            class="says reflect-return text-left"
                          />
                          <p class="time">
                            {{ $dayjs(message.created_at).format("HH:mm") }}
                          </p>
                        </div>
                      </v-col>
                      <v-col v-if="message.band_id === bandId">
                        <div class="balloon_r">
                          <p class="time">
                            {{ $dayjs(message.created_at).format("HH:mm") }}
                          </p>
                          <div class="face_icon">
                            <v-avatar size="40">
                              <v-img :src="bandImage(message.band_image)" />
                            </v-avatar>
                          </div>
                          <p
                            v-text="message.content"
                            class="says reflect-return black--text text-left"
                          />
                        </div>
                      </v-col>
                    </v-row>
                  </template>
                </v-container>
              </v-col>
            </v-row>
          </v-card-text>
          <v-divider />
          <v-card-text>
            <v-row>
              <v-col>
                <ValidationProvider
                  name="メッセージ"
                  rules="max:1000|required"
                  v-slot="{ errors }"
                >
                  <v-textarea
                    v-model="inputMessage"
                    :error-messages="errorMessage"
                    label="メッセージ"
                    rows="1"
                    auto-grow
                    autofocus
                    clearable
                  />
                  <v-btn color="grey darken-2" @click="sendMessage(errors)">
                    送信
                  </v-btn>
                </ValidationProvider>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import CardAvatar from "@/components/Cards/CardAvatar";
import { ValidationProvider } from "vee-validate";

export default {
  components: {
    CardAvatar,
    ValidationProvider,
  },
  props: ["id", "roomId"],
  data() {
    return {
      inputMessage: "",
      errorMessage: "",
      messages: [],
      partner: {},
    };
  },
  channels: {
    RoomChannel: {
      received(data) {
        this.messages.push(data);
      },
    },
  },
  async created() {
    try {
      if (Number(this.id) !== this.bandId) {
        return this.$router.replace("/");
      } else {
        const res = await this.$axios.get(`/rooms/${this.roomId}/messages`, {
          headers: this.token,
          params: { band_id: this.$route.query.partnerId },
        });
        this.messages = res.data.messages;
        this.partner = res.data.partner;
        const params = `uid=${this.token["uid"]}&access-token=${this.token["access-token"]}&client=${this.token["client"]}`;
        this.$cable.connection.connect(
          `wss://${process.env.VUE_APP_WS}/cable?${params}`
        );
        this.$cable.subscribe({ channel: "RoomChannel", room: this.roomId });
        this.scrollToEnd();
      }
    } catch (error) {
      if (error.response) this.$router.replace("/errors/not_found");
    }
  },
  updated() {
    this.scrollToEnd();
  },
  beforeRouteLeave(to, from, next) {
    this.$cable.connection.disconnect();
    next();
  },
  computed: {
    ...mapGetters(["bandId", "token"]),
    isFirstContentInDate() {
      return (messageId) => {
        const firstMessagesInDate = Array.from(
          new Map(
            this.messages
              .slice()
              .reverse()
              .map((message) => [
                this.$dayjs(message.created_at).format("YYYY MMM DD"),
                message,
              ])
          ).values()
        );
        return firstMessagesInDate.some((f) => f.id === messageId);
      };
    },
    bandImage() {
      return (image) => {
        return image ? image : require("@/assets/img/no-band-img.jpg");
      };
    },
  },
  methods: {
    sendMessage(errors) {
      if (errors.length) {
        return (this.errorMessage = errors);
      } else {
        this.errorMessage = "";
        this.$cable.perform({
          channel: "RoomChannel",
          room: this.roomId,
          action: "speak",
          data: { message: this.inputMessage },
        });
        this.inputMessage = "";
      }
    },
    scrollToEnd() {
      this.$nextTick(() => {
        const container = this.$refs.scrollTarget;
        container.scrollTop = container.scrollHeight;
      });
    },
  },
};
</script>

<style scoped>
.balloon_l,
.balloon_r {
  margin: 10px 0;
  display: flex;
  justify-content: flex-start;
  align-items: flex-start;
}
.balloon_r {
  justify-content: flex-end;
}
.face_icon img {
  width: 80px;
  height: auto;
}
.balloon_r .face_icon {
  margin-left: 25px;
}
.balloon_l .face_icon {
  margin-right: 25px;
}
.balloon_r .face_icon {
  order: 2 !important;
}
.time {
  margin: 0 5px;
}
.says {
  max-width: 300px;
  display: flex;
  flex-wrap: wrap;
  position: relative;
  padding: 10px;
  border-radius: 12px;
  box-sizing: border-box;
  margin: 0 !important;
  line-height: 1.5;
  /*   align-items: center; */
}
.says p {
  margin: 8px 0 0 !important;
}
.says p:first-child {
  margin-top: 0 !important;
}
.says:after {
  content: "";
  position: absolute;
  border: 10px solid transparent;
  margin-top: -3px;
}
.balloon_l .says {
  background: #505050;
}
.balloon_l .says:after {
  left: -26px;
  border-right: 22px solid #505050;
}
.balloon_r .says {
  background: #f1f1f1;
}
.balloon_r .says:after {
  right: -26px;
  border-left: 22px solid #f1f1f1;
}
</style>
