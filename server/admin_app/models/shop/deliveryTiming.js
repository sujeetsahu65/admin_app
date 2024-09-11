
module.exports = (superSequelize, DataTypes) =>
{
  const DeliverTiming = superSequelize.define('DeliverTiming', {
    dayNumber: {
      type: DataTypes.INTEGER,
      field: 'dayname'
    }, // Days 0-6 (Monday to Sunday)
    fromTime: {
      type: DataTypes.TIME,
      field: 'fromtime'
    },
    toTime: {
      type: DataTypes.TIME,
      field: 'totime'
    },
    nextDay: {
      type: DataTypes.INTEGER, defaultValue: 0,
      field: 'nextday'
    }, // 1 if close time is after midnight
    closeStatus: {
      type: DataTypes.TINYINT(1), defaultValue: 1,
      field: 'close_status'
    }, // 1=Open, 0=Closed
    tableName: {
      type: DataTypes.VIRTUAL,
      get ()
      {
        return 'delivery_timings';  // This value is set manually as it's not in the database
      }
    }
  },

    {
      timestamps: false,
      tableName: "delivery_timings"
    });
  return DeliverTiming;
};

// module.exports = Admin;