<template>
  <div class="d-flex align-items-center justify-content-center flex-column bg-white">
    <p v-if="value || value === 0" style="font-size: 60px" class="fw-bold">
      {{ value }}
    </p>
    <p v-else-if="!loading">
      {{ i18n['no_data'] }}
    </p>

    <span v-if="showTrends" class="badge rounded-pill px-2 py-1" :class="{'bg-kpi-up': isPositiveChange, 'bg-kpi-down': isNegativeChange, 'bg-kpi-neutral': isNoChange}">
      <i v-if="isPositiveChange" class="ion ion-md-arrow-up mx-1 text-kpi-up"></i>
      <i v-if="isNegativeChange" class="ion ion-md-arrow-down mx-1 text-kpi-down"></i>

      <span :class="{'text-kpi-up': isPositiveChange, 'text-kpi-down': isNegativeChange, 'text-kpi-neutral': isNoChange }">
        {{ change }} {{ label }}
      </span>

    </span>

  </div>
</template>

<script>
export default {
  name: 'KPIResult',
  props: {
    data: {
      type: Array,
      required: false,
      default: () => ([])
    },
    loading: {
      type: Boolean,
      required: false,
      default: false
    },
    valueFormat: {
      type: Object,
      required: false,
      default: () => ({ style: 'decimal' })
    }
  },
  computed: {
    dataRow() {
      return this.data[0] || []
    },
    isPositiveChange() {
      return !this.change.toString().match(/^-/) && this.change !== 0
    },
    isNoChange() {
      return this.change === 0;
    },
    isNegativeChange() {
      return this.change.toString().match(/^-/)
    },

    value() {
      return this.label ? this.dataRow[1] : this.dataRow[0]
    },
    change() {
      return this.label ? this.dataRow[2] : this.dataRow[1]
    },
    label() {
      if (this.dataRow.length >= 3) {
        return typeof this.dataRow[0] === 'string' ? this.dataRow[0] : ''
      } else {
        return ''
      }
    },
    showTrends() {
      if(this.dataRow[3] == false) {
        return false;
      }

      return (this.change || this.change === 0);
    }
  }
}
</script>
