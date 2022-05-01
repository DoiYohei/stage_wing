<template>
  <v-container fluid>
    <v-row>
      <v-col
        cols="12"
        xl="2"
        lg="3"
        :class="$vuetify.breakpoint.mdAndDown ? 'pa-0' : 'mt-3'"
      >
        <v-card :outlined="$vuetify.breakpoint.mdAndDown">
          <v-col
            lg="12"
            sm="6"
            :class="$vuetify.breakpoint.mdAndDown ? 'py-0' : 'pt-0'"
          >
            <v-card-actions class="pt-0">
              <v-text-field
                v-model="keywordInput"
                placeholder="Band名を入力してください"
                prepend-inner-icon="mdi-magnify"
                clearable
                hide-details
              />
            </v-card-actions>
          </v-col>
        </v-card>
      </v-col>
      <v-col>
        <v-card color="#121212" flat class="d-flex flex-wrap">
          <v-col
            v-for="(band, index) in displayBands"
            :key="index"
            cols="6"
            xl="2"
            md="3"
            sm="4"
          >
            <v-card :to="`/bands/${band.id}`">
              <v-img :src="bandImage(band.image.url)" aspect-ratio="1.37" />
              <v-card-subtitle>
                {{ band.name }}
              </v-card-subtitle>
            </v-card>
          </v-col>
        </v-card>
        <v-col>
          <PaginationBlocks @chage-page="moldDisplay" />
        </v-col>
        <v-col v-if="!displayBands.length">
          <v-card color="#121212" flat>
            <v-card-text class="text-center">
              該当するアーティストがいません
            </v-card-text>
          </v-card>
        </v-col>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import PaginationBlocks from "@/components/PaginationBlocks";
export default {
  components: {
    PaginationBlocks,
  },
  data() {
    return {
      allBands: [],
      keywordInput: "",
      displayBands: [],
    };
  },
  async created() {
    const res = await this.$axios.get("/bands");
    this.allBands = res.data.bands;
    this.moldDisplay();
  },
  computed: {
    filteredBands() {
      if (!this.keywordInput) {
        return this.allBands;
      } else {
        const keyword = this.keywordInput.toLowerCase().trim();
        return this.allBands.filter((band) => {
          return band.name.toLowerCase().includes(keyword);
        });
      }
    },
    rowsPerPage() {
      return this.$vuetify.breakpoint.smAndDown ? 10 : 30;
    },
    bandImage() {
      return (image) => {
        return image ? image : require("@/assets/img/no-band-img.jpg");
      };
    },
  },
  methods: {
    moldDisplay() {
      this.$page.rowsPerPage = this.rowsPerPage;
      this.$page.displayContents = this.filteredBands;
      this.displayBands = this.$page.displayContents;
    },
  },
  watch: {
    filteredBands() {
      this.$page.current = 1;
      this.moldDisplay();
    },
  },
};
</script>
